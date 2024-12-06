part of 'get_profile_followers_bloc.dart';

sealed class GetProfileFollowersState extends Equatable {
  final List<ProfileModel> users;
  final int? page;
  final bool canLoadMore;

  const GetProfileFollowersState(
      {required this.users, required this.page, required this.canLoadMore});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class GetProfileFollowersInitialState extends GetProfileFollowersState {
  const GetProfileFollowersInitialState({
    super.users = const [],
    super.page = 1,
    super.canLoadMore = true,
  });
}

final class GetProfileFollowersLoadingState extends GetProfileFollowersState {
  const GetProfileFollowersLoadingState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetProfileFollowersNoInternetConnectionState
    extends GetProfileFollowersState {
  const GetProfileFollowersNoInternetConnectionState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetProfileFollowersLoadedState extends GetProfileFollowersState {
  const GetProfileFollowersLoadedState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetProfileFollowersErrorState extends GetProfileFollowersState {
  final String message;

  const GetProfileFollowersErrorState(
      {required this.message,
      required super.users,
      required super.page,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, users, page, canLoadMore];
}
