import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import 'package:frontend_trend/injection_container.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/entities/paged_list.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repository/profile_repository.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../../../core/utils/toast_utils.dart';
import '../../../data/models/profile_form_data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required this.profileRepository,
  }) : super(const ProfileInitial()) {
    on<FetchProfileInfoEv>(
      _onFetchProfileInfoEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
    on<UpdateProfileInfoEv>(_onUpdateProfileInfoEvent);
    on<ToggleFollowEv>(_onToggleFollowEvent);
  }
  final ProfileRepository profileRepository;
  bool isLoading = false;
  EventTransformer<PostsEvent> _debounceAndSwitch<PostsEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  FutureOr<void> _onFetchProfileInfoEvent(
      FetchProfileInfoEv event, Emitter<ProfileState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(ProfileLoadingState(
        profile: null,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
      ));
    }

    final failureOrProfile =
        await profileRepository.getUserProfile(event.profileId, event.params);
    emit(failureOrProfile.fold(
      (failure) => _mapFailureToState(failure),
      (profile) => ProfileLoadedState(
          page: event.params.page,
          canLoadMore: profile.posts.nextPageNumber != null,
          profile: profile.copyWith(posts: null)),
    ));
    isLoading = false;
  }

  FutureOr<void> _onUpdateProfileInfoEvent(
      UpdateProfileInfoEv event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState(
        page: state.page,
        canLoadMore: state.canLoadMore,
        profile: state.profile));
    final failureOrSuccess =
        await profileRepository.editUserProfile(event.formData);
    failureOrSuccess.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (profile) async {
        event.context.read<CurrentUserCubit>().updateCurrentUser(profile);
        ToastUtils(event.context).showCustomToast(
          message: "Profile updated successfully".hardcoded,
          iconData: Icons.check_circle_outline,
        );
        await Future.delayed(Duration(seconds: 1));
        add(FetchProfileInfoEv(
          profileId: profile.id,
          params: PaginationParam(page: 1),
        ));

        Get.back();
      },
    );
  }

  ProfileState _mapFailureToState(Failure failure) {
    if (failure is NoInternetConnectionFailure) {
      return ProfileNoInternetConnectionState(
          page: state.page,
          canLoadMore: state.canLoadMore,
          profile: state.profile);
    }

    return ProfileErrorState(
        page: state.page,
        canLoadMore: state.canLoadMore,
        message: AppStrings.someThingWentWrong,
        profile: state.profile);
  }

  FutureOr<void> _onToggleFollowEvent(
      ToggleFollowEv event, Emitter<ProfileState> emit) async {
    emit(ProfileFollowLoadingState(
        page: state.page,
        canLoadMore: state.canLoadMore,
        profile: state.profile));
    final failureOrSuccess =
        await profileRepository.toggleFollow(event.otherUserId, event.isFollow);

    failureOrSuccess.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (isFollow) {
        // event.context.read<GetProfileFollowingBloc>().add(
        //   FetchProfileFollowingEvent(
        //       params: PaginationParam(page: 1),
        //       profileId: sl<SharedPref>().account!.id));
        add(FetchProfileInfoEv(
            profileId: event.otherUserId,
            params: PaginationParam(page: 1),
            emitLoading: false));

        event.context.read<GetProfileFollowingBloc>().add(
            FetchProfileFollowingEvent(
                params: PaginationParam(page: 1),
                profileId: sl<SharedPref>().account!.id));
      },
    );
  }
}
