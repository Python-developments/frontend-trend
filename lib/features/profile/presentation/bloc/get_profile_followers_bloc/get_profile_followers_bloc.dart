import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/transformers.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
part 'get_profile_followers_event.dart';
part 'get_profile_followers_state.dart';

class GetProfileFollowersBloc
    extends Bloc<GetProfileFollowersEvent, GetProfileFollowersState> {
  final ProfileRepository profileRepository;
  bool isLoading = false;

  GetProfileFollowersBloc({required this.profileRepository})
      : super(const GetProfileFollowersInitialState()) {
    on<FetchProfileFollowersEvent>(
      _onFetchProfileFollowersEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
  }

  EventTransformer<GetProfileFollowersEvent>
      _debounceAndSwitch<GetProfileFollowersEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  GetProfileFollowersState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return GetProfileFollowersErrorState(
          message: failure.message,
          users: state.users,
          page: state.page,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return GetProfileFollowersNoInternetConnectionState(
          users: state.users, page: state.page, canLoadMore: state.canLoadMore);
    } else {
      return GetProfileFollowersErrorState(
          users: state.users,
          message: AppStrings.someThingWentWrong,
          page: state.page,
          canLoadMore: state.canLoadMore);
    }
  }

  FutureOr<void> _onFetchProfileFollowersEvent(FetchProfileFollowersEvent event,
      Emitter<GetProfileFollowersState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(GetProfileFollowersLoadingState(
        users: event.params.page == 1 ? const [] : state.users,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
      ));
    }
    final failureOrusers = await profileRepository.getProfileFollowers(
        event.profileId, event.params);
    failureOrusers.fold((failure) => emit(_mapFailureToState(failure)),
        (usersPagedList) {
      emit(
        GetProfileFollowersLoadedState(
          users: List.of(state.users)..addAll(usersPagedList.items),
          page: event.params.page,
          canLoadMore: usersPagedList.nextPageNumber != null,
        ),
      );
    });
    isLoading = false;
  }
}
