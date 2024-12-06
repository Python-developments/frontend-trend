import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/transformers.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
part 'get_profile_following_event.dart';
part 'get_profile_following_state.dart';

class GetProfileFollowingBloc
    extends Bloc<GetProfileFollowingEvent, GetProfileFollowingState> {
  final ProfileRepository profileRepository;
  bool isLoading = false;

  GetProfileFollowingBloc({required this.profileRepository})
      : super(const GetProfileFollowingInitialState()) {
    on<FetchProfileFollowingEvent>(
      _onFetchProfileFollowingEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
  }

  EventTransformer<GetProfileFollowingEvent>
      _debounceAndSwitch<GetProfileFollowingEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  GetProfileFollowingState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return GetProfileFollowingErrorState(
          message: failure.message,
          users: state.users,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return GetProfileFollowingNoInternetConnectionState(
          users: state.users, page: state.page, canLoadMore: state.canLoadMore);
    } else {
      return GetProfileFollowingErrorState(
          users: state.users,
          message: AppStrings.someThingWentWrong,
          page: state.page,
          canLoadMore: state.canLoadMore);
    }
  }

  FutureOr<void> _onFetchProfileFollowingEvent(FetchProfileFollowingEvent event,
      Emitter<GetProfileFollowingState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(GetProfileFollowingLoadingState(
        users: event.params.page == 1 ? const [] : state.users,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
      ));
    }
    final failureOrusers = await profileRepository.getProfileFollowing(
        event.profileId, event.params);
    failureOrusers.fold((failure) => emit(_mapFailureToState(failure)),
        (usersPagedList) {
      emit(
        GetProfileFollowingLoadedState(
          users: List.of(state.users)..addAll(usersPagedList.items),
          page: event.params.page,
          canLoadMore: usersPagedList.nextPageNumber != null,
        ),
      );
    });
    isLoading = false;
  }
}
