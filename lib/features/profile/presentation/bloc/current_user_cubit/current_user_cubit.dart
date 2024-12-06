import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_trend/core/utils/entities/pagination_param.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'package:frontend_trend/features/authentication/data/models/user_model.dart';
import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
import 'package:frontend_trend/features/profile/data/repository/profile_repository.dart';
part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  final ProfileRepository profileRepository;
  final SharedPref sharedPref;
  CurrentUserCubit(this.profileRepository, this.sharedPref)
      : super(const CurrentUserState(user: null));

  updateCurrentUser(ProfileModel profile) async {
    final currentCachedUser = sharedPref.account;

    try {
      if (currentCachedUser != null) {
        final newUser = sharedPref.account!.copyWith(avatar: profile.avatar);
        sharedPref.updateAccount(newUser);
        if (newUser.avatar != currentCachedUser.avatar) {
          emit(CurrentUserState(user: newUser));
        }
      }
    } catch (_) {
      emit(CurrentUserState(user: currentCachedUser));
    }
  }

  fetchCurrentUser() async {
    final currentCachedUser = sharedPref.account;
    emit(CurrentUserState(user: currentCachedUser));
    try {
      if (currentCachedUser != null) {
        final userOrFailure = await profileRepository.getUserProfile(
            currentCachedUser.profileId, PaginationParam(page: 1));

        userOrFailure.fold((_) {}, (remoteUser) {
          final newUser =
              sharedPref.account!.copyWith(avatar: remoteUser.avatar);

          sharedPref.updateAccount(newUser);

          // if (newUser.avatar != currentCachedUser.avatar) {
          emit(CurrentUserState(user: newUser));
          // }
        });
      }
    } catch (_) {
      emit(CurrentUserState(user: currentCachedUser));
    }
  }
}
