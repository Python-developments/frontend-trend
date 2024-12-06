import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/transformers.dart';
import '../../../../profile/data/models/profile_model.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../data/repository/posts_repository.dart';
part 'get_likes_users_by_post_event.dart';
part 'get_likes_users_by_post_state.dart';

class GetLikesUsersByPostBloc
    extends Bloc<GetLikesUsersByPostEvent, GetLikesUsersByPostState> {
  final PostsRepository postsRepository;
  bool isLoading = false;

  GetLikesUsersByPostBloc({required this.postsRepository})
      : super(const GetLikesUsersByPostInitialState()) {
    on<FetchLikesUsersByPostEvent>(
      _onFetchLikesUsersByPostEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
  }

  EventTransformer<GetLikesUsersByPostEvent>
      _debounceAndSwitch<GetLikesUsersByPostEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  GetLikesUsersByPostState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return GetLikesUsersByPostErrorState(
          message: failure.message,
          users: state.users,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return GetLikesUsersByPostNoInternetConnectionState(
          users: state.users, page: state.page, canLoadMore: state.canLoadMore);
    } else {
      return GetLikesUsersByPostErrorState(
          users: state.users,
          message: AppStrings.someThingWentWrong,
          page: state.page,
          canLoadMore: state.canLoadMore);
    }
  }

  FutureOr<void> _onFetchLikesUsersByPostEvent(FetchLikesUsersByPostEvent event,
      Emitter<GetLikesUsersByPostState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(GetLikesUsersByPostLoadingState(
        users: event.params.page == 1 ? const [] : state.users,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
      ));
    }
    final failureOrusers =
        await postsRepository.getLikesUsersByPost(event.postId, event.params);
    failureOrusers.fold((failure) => emit(_mapFailureToState(failure)),
        (usersPagedList) {
      emit(
        GetLikesUsersByPostLoadedState(
          users: List.of(state.users)..addAll(usersPagedList.items),
          page: event.params.page,
          canLoadMore: usersPagedList.nextPageNumber != null,
        ),
      );
    });
    isLoading = false;
  }
}
