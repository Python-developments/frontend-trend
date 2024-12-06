import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/models/comment_model.dart';
import '../posts_bloc/posts_bloc.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../data/models/params/add_comment_params.dart';
import '../../../data/repository/posts_repository.dart';
part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final PostsRepository postsRepository;
  bool isLoading = false;
  final TextEditingController commentController = TextEditingController();
  ScrollController scrollController = ScrollController();

  CommentsBloc({required this.postsRepository})
      : super(const CommentsInitialState()) {
    on<GetCommentsByPostEvent>(
      _onGetCommentsByPostEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );

    on<AddCommentEvent>(_onAddCommentEvent);
  }

  EventTransformer<CommentsEvent> _debounceAndSwitch<CommentsEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  CommentsState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return CommentsErrorState(
          message: failure.message,
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return CommentsNoInternetConnectionState(
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else {
      return CommentsErrorState(
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

  FutureOr<void> _onGetCommentsByPostEvent(
      GetCommentsByPostEvent event, Emitter<CommentsState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(CommentsLoadingState(
        comments: event.params.page == 1 ? const [] : state.comments,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
      ));
    }
    final failureOrcomments =
        await postsRepository.getCommentsByPost(event.postId, event.params);
    failureOrcomments.fold((failure) => emit(_mapFailureToState(failure)),
        (commentsPagedList) {
      emit(
        CommentsLoadedState(
          comments: List.of(state.comments)..addAll(commentsPagedList.items),
          page: event.params.page,
          canLoadMore: commentsPagedList.nextPageNumber != null,
        ),
      );
    });
    isLoading = false;
    if (event.scrollToBottom) {
      _scrollToTop();
    }
  }

  FutureOr<void> _onAddCommentEvent(
      AddCommentEvent event, Emitter<CommentsState> emit) async {
    if (event.emitLoading) {
      emit(CommentsLoadingState(
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore));
    }
    final result = await postsRepository.addComment(event.params);

    result.fold((failure) => emit(_mapFailureToState(failure)), (_) {
      emit(CommentAddedSuccessState(
          comments: state.comments,
          page: state.page,
          canLoadMore: state.canLoadMore));

      event.context.read<PostsBloc>().add(UpdateCommentsCountForPostEvent(
          isIncrease: true, postId: event.params.postId));

      commentController.clear();
      add(GetCommentsByPostEvent(
          params: PaginationParam(page: state.page ?? 1),
          postId: event.params.postId,
          scrollToBottom: true));
    });
  }
}
