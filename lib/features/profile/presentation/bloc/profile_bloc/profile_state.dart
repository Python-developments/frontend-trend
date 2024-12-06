part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  final ProfileModel? profile;
  final int? page;
  final bool canLoadMore;
  const ProfileState({
    required this.profile,
    required this.page,
    required this.canLoadMore,
  });

  @override
  List<Object?> get props => [identityHashCode(this)];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial(
      {super.profile, super.page = 1, super.canLoadMore = true});
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState(
      {required super.profile,
      required super.page,
      required super.canLoadMore});
}

class ProfileFollowLoadingState extends ProfileState {
  const ProfileFollowLoadingState(
      {required super.profile,
      required super.page,
      required super.canLoadMore});
}

class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState(
      {required super.profile,
      required super.page,
      required super.canLoadMore});
}

class ProfileNoInternetConnectionState extends ProfileState {
  const ProfileNoInternetConnectionState(
      {required super.profile,
      required super.page,
      required super.canLoadMore});
}

class ProfileErrorState extends ProfileState {
  final String message;
  const ProfileErrorState({
    required this.message,
    required super.profile,
    required super.page,
    required super.canLoadMore,
  });

  @override
  List<Object> get props => [message];
}
