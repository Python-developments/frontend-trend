part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileInfoEv extends ProfileEvent {
  final PaginationParam params;
  final bool emitLoading;
  final int profileId;

  const FetchProfileInfoEv({
    required this.profileId,
    required this.params,
    this.emitLoading = true,
  });

  @override
  List<Object> get props => [profileId, params];
}

class UpdateProfileInfoEv extends ProfileEvent {
  final ProfileFormData formData;
  final BuildContext context;

  const UpdateProfileInfoEv({
    required this.formData,
    required this.context,
  });
}

class ToggleFollowEv extends ProfileEvent {
  final int otherUserId;
  final bool isFollow;
  final BuildContext context;

  const ToggleFollowEv({
    required this.otherUserId,
    required this.isFollow,
    required this.context,
  });
}
