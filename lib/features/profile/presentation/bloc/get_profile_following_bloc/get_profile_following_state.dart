part of 'get_profile_following_bloc.dart';

sealed class GetProfileFollowingState extends Equatable {
  final List<ProfileModel> users;
  final int? page;
  final bool canLoadMore;

  const GetProfileFollowingState(
      {required this.users, required this.page, required this.canLoadMore});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class GetProfileFollowingInitialState extends GetProfileFollowingState {
  const GetProfileFollowingInitialState({
    super.users = const [],
    super.page = 1,
    super.canLoadMore = true,
  });
}

final class GetProfileFollowingLoadingState extends GetProfileFollowingState {
  const GetProfileFollowingLoadingState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetProfileFollowingNoInternetConnectionState
    extends GetProfileFollowingState {
  const GetProfileFollowingNoInternetConnectionState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetProfileFollowingLoadedState extends GetProfileFollowingState {
  const GetProfileFollowingLoadedState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetProfileFollowingErrorState extends GetProfileFollowingState {
  final String message;

  const GetProfileFollowingErrorState(
      {required this.message,
      required super.users,
      required super.page,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, users, page, canLoadMore];
}
