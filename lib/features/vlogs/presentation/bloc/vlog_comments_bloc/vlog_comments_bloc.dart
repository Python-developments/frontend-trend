import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../data/models/params/add_vlog_comment_params.dart';
import '../../../data/models/vlog_comment_model.dart';
import '../../../data/repository/vlogs_repository.dart';
import '../vlogs_bloc/vlogs_bloc.dart';
part 'vlog_comments_event.dart';
part 'vlog_comments_state.dart';

class VlogCommentsBloc extends Bloc<VlogCommentsEvent, VlogCommentsState> {
  final VlogsRepository vlogsRepository;
  bool isLoading = false;
  final TextEditingController commentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  VlogCommentsBloc({required this.vlogsRepository})
      : super(const VlogCommentsInitialState()) {
    on<GetCommentsByVlogEvent>(
      _onGetCommentsByVlogEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );

    on<AddCommentEvent>(_onAddCommentEvent);
  }

  EventTransformer<VlogCommentsEvent> _debounceAndSwitch<VlogCommentsEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  VlogCommentsState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return VlogCommentsErrorState(
          message: failure.message,
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return VlogCommentsNoInternetConnectionState(
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else {
      return VlogCommentsErrorState(
          comments: state.comments,
          message: AppStrings.someThingWentWrong,
          page: state.page,
          canLoadMore: state.canLoadMore);
    }
  }

  void _scrollToTop() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  FutureOr<void> _onGetCommentsByVlogEvent(
      GetCommentsByVlogEvent event, Emitter<VlogCommentsState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(VlogCommentsLoadingState(
        comments: event.params.page == 1 ? const [] : state.comments,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
      ));
    }
    final failureOrVlogcomments =
        await vlogsRepository.getCommentsByVlog(event.vlogId, event.params);
    failureOrVlogcomments.fold((failure) => emit(_mapFailureToState(failure)),
        (vlogcommentsPagedList) {
      emit(
        VlogCommentsLoadedState(
          comments: List.of(state.comments)
            ..addAll(vlogcommentsPagedList.items),
          page: event.params.page,
          canLoadMore: vlogcommentsPagedList.nextPageNumber != null,
        ),
      );
    });
    isLoading = false;
    if (event.scrollToBottom) {
      _scrollToTop();
    }
  }

  FutureOr<void> _onAddCommentEvent(
      AddCommentEvent event, Emitter<VlogCommentsState> emit) async {
    if (event.emitLoading) {
      emit(VlogCommentsLoadingState(
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore));
    }
    final result = await vlogsRepository.addComment(event.params);

    result.fold((failure) => emit(_mapFailureToState(failure)), (_) {
      emit(CommentAddedSuccessState(
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore));
      commentController.clear();
      event.vlogsVloc.add(UpdateCommentsCountForVlogEvent(
          isIncrease: true, vlogId: event.params.vlogId));

      add(GetCommentsByVlogEvent(
          params: PaginationParam(page: state.page ?? 1),
          vlogId: event.params.vlogId,
          scrollToBottom: true));
    });
  }
}
