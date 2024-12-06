import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/repository/vlogs_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../data/models/params/add_vlog_params.dart';
import '../../../data/models/vlog_model.dart';

part 'vlogs_event.dart';
part 'vlogs_state.dart';

class VlogsBloc extends Bloc<VlogsEvent, VlogsState> {
  final VlogsRepository vlogsRepository;
  VlogsBloc({required this.vlogsRepository})
      : super(const VlogsInitialState()) {
    on<GetAllVlogsEvent>(
      _onGetAllVlogsEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
    on<GetProfileVlogsEvent>(
      _onGetProfileVlogsEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
    on<AddVlogEvent>(_onAddVlogEvent);
    on<DeleteVlogEvent>(_onDeleteVlogEvent);
    on<ToggleLikeEvent>(_onToggleLikeEvent);
    on<FetchSingleVlogEvent>(_onFetchSingleVlogEvent);
    on<UpdateCommentsCountForVlogEvent>(_onUpdateCommentsCountForVlogEvent);
  }
  bool isLoading = false;
  EventTransformer<VlogsEvent> _debounceAndSwitch<VlogsEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  FutureOr<void> _onGetAllVlogsEvent(
      GetAllVlogsEvent event, Emitter<VlogsState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(VlogsLoadingState(
        vlogs: event.params.page == 1 ? const [] : state.vlogs,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
        currentVlog: state.currentVlog,
      ));
    }
    final failureOrVlogs = await vlogsRepository.getAllVlogs(event.params);
    emit(failureOrVlogs.fold(
      (failure) => _mapFailureToState(failure),
      (vlogsPagedList) => VlogsLoadedState(
        vlogs: event.params.page != 1
            ? (List.of(state.vlogs)..addAll(vlogsPagedList.items))
            : vlogsPagedList.items,
        page: event.params.page,
        canLoadMore: vlogsPagedList.nextPageNumber != null,
        currentVlog: state.currentVlog,
      ),
    ));
    isLoading = false;
  }

  FutureOr<void> _onAddVlogEvent(
      AddVlogEvent event, Emitter<VlogsState> emit) async {
    emit(VlogsLoadingState(
      vlogs: state.vlogs,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentVlog: state.currentVlog,
    ));

    final result = await vlogsRepository.addVlog(event.params);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        emit(VlogAddedSuccessState(
            vlogs: state.vlogs,
            page: state.page,
            currentVlog: state.currentVlog,
            canLoadMore: state.canLoadMore));
        add(GetAllVlogsEvent(params: PaginationParam(page: 1)));
      },
    );
  }

  FutureOr<void> _onDeleteVlogEvent(
      DeleteVlogEvent event, Emitter<VlogsState> emit) async {
    emit(VlogsLoadingState(
      vlogs: state.vlogs,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentVlog: state.currentVlog,
    ));
    final result = await vlogsRepository.deleteVlog(event.vlogId);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        final vlogs = state.vlogs
          ..removeWhere((element) => element.id == event.vlogId);
        emit(VlogDeletedSuccessState(
          vlogs: vlogs,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentVlog: state.currentVlog,
        ));
        emit(VlogsLoadedState(
          vlogs: vlogs,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentVlog: state.currentVlog,
        ));
      },
    );
  }

  FutureOr<void> _onToggleLikeEvent(
      ToggleLikeEvent event, Emitter<VlogsState> emit) async {
    List<VlogModel> vlogs = state.vlogs;
    VlogModel? currentVlog = event.vlog.id == state.currentVlog?.id
        ? state.currentVlog!.copyWith(
            likedByUser: !state.currentVlog!.likedByUser,
            likeCount: state.currentVlog!.likedByUser
                ? state.currentVlog!.likeCount + 1
                : state.currentVlog!.likeCount - 1)
        : state.currentVlog;
    final index = vlogs.indexWhere((p) => p.id == event.vlog.id);
    vlogs
      ..removeAt(index)
      ..insert(
          index,
          event.vlog.copyWith(
            likedByUser: !event.vlog.likedByUser,
            likeCount: event.vlog.likedByUser
                ? event.vlog.likeCount - 1
                : event.vlog.likeCount + 1,
          ));

    currentVlog = event.vlog.id == state.currentVlog?.id
        ? state.currentVlog!.copyWith(
            likedByUser: !state.currentVlog!.likedByUser,
            likeCount: state.currentVlog!.likedByUser
                ? state.currentVlog!.likeCount - 1
                : state.currentVlog!.likeCount + 1)
        : state.currentVlog;

    emit(VlogsLoadingState(
      vlogs: vlogs,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentVlog: currentVlog,
    ));
    // emit(VlogsLoadedState(vlogs: vlogs));
    final result = await vlogsRepository.toggleLike(event.vlog.id);
    result.fold(
      (failure) {
        vlogs
          ..removeAt(index)
          ..insert(
              index,
              event.vlog.copyWith(
                likedByUser: event.vlog.likedByUser,
                likeCount: event.vlog.likeCount,
              ));
        currentVlog = event.vlog.id == state.currentVlog?.id
            ? state.currentVlog!.copyWith(
                likedByUser: !state.currentVlog!.likedByUser,
                likeCount: state.currentVlog!.likedByUser
                    ? state.currentVlog!.likeCount + 1
                    : state.currentVlog!.likeCount - 1)
            : state.currentVlog;
        emit(VlogsLoadedState(
          vlogs: vlogs,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentVlog: currentVlog,
        ));
      },
      (likedByUser) {
        vlogs
          ..removeAt(index)
          ..insert(
              index,
              event.vlog.copyWith(
                likedByUser: likedByUser,
                likeCount: likedByUser
                    ? event.vlog.likeCount + 1
                    : event.vlog.likeCount - 1,
              ));
      },
    );

    emit(VlogsLoadedState(
      vlogs: vlogs,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentVlog: currentVlog,
    ));
  }

  VlogsState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return VlogsErrorState(
          message: (failure).message,
          vlogs: state.vlogs,
          page: state.page,
          currentVlog: state.currentVlog,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return VlogsNoInternetConnectionState(
        vlogs: state.vlogs,
        page: state.page,
        canLoadMore: state.canLoadMore,
        currentVlog: state.currentVlog,
      );
    } else {
      return VlogsErrorState(
          vlogs: state.vlogs,
          message: AppStrings.someThingWentWrong,
          page: state.page,
          currentVlog: state.currentVlog,
          canLoadMore: state.canLoadMore);
    }
  }

  FutureOr<void> _onFetchSingleVlogEvent(
      FetchSingleVlogEvent event, Emitter<VlogsState> emit) async {
    emit(VlogsLoadingState(
      vlogs: state.vlogs,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentVlog: state.currentVlog,
    ));

    final vlogOrFailure = await vlogsRepository.getVlogDetails(event.vlogId);
    emit(vlogOrFailure.fold(
        (failure) => _mapFailureToState(failure),
        (vlog) => VlogsLoadedState(
              vlogs: state.vlogs,
              page: state.page,
              canLoadMore: state.canLoadMore,
              currentVlog: vlog,
            )));
  }

  FutureOr<void> _onUpdateCommentsCountForVlogEvent(
      UpdateCommentsCountForVlogEvent event, Emitter<VlogsState> emit) {
    final newVlogs = state.vlogs
        .map((p) => p.id == event.vlogId
            ? p.copyWith(
                commentCount:
                    event.isIncrease ? p.commentCount + 1 : p.commentCount - 1)
            : p)
        .toList();
    final currentVlog =
        state.currentVlog != null && state.currentVlog?.id == event.vlogId
            ? state.currentVlog?.copyWith(
                commentCount: event.isIncrease
                    ? state.currentVlog!.commentCount + 1
                    : state.currentVlog!.commentCount - 1)
            : state.currentVlog;
    emit(VlogsLoadedState(
      vlogs: newVlogs,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentVlog: currentVlog,
    ));
  }

  FutureOr<void> _onGetProfileVlogsEvent(
      GetProfileVlogsEvent event, Emitter<VlogsState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(VlogsLoadingState(
        vlogs: event.params.page == 1 ? const [] : state.vlogs,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
        currentVlog: state.currentVlog,
      ));
    }
    final failureOrVlogs =
        await vlogsRepository.getProfileVlogs(event.profileId, event.params);
    emit(failureOrVlogs.fold(
      (failure) => _mapFailureToState(failure),
      (vlogsPagedList) => VlogsLoadedState(
        vlogs: List.of(state.vlogs)..addAll(vlogsPagedList.items),
        page: event.params.page,
        canLoadMore: vlogsPagedList.nextPageNumber != null,
        currentVlog: state.currentVlog,
      ),
    ));
    isLoading = false;
  }
}
