part of 'get_likes_users_by_post_bloc.dart';

sealed class GetLikesUsersByPostState extends Equatable {
  final List<ProfileModel> users;
  final int? page;
  final bool canLoadMore;

  const GetLikesUsersByPostState(
      {required this.users, required this.page, required this.canLoadMore});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class GetLikesUsersByPostInitialState extends GetLikesUsersByPostState {
  const GetLikesUsersByPostInitialState({
    super.users = const [],
    super.page = 1,
    super.canLoadMore = true,
  });
}

final class GetLikesUsersByPostLoadingState extends GetLikesUsersByPostState {
  const GetLikesUsersByPostLoadingState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetLikesUsersByPostNoInternetConnectionState
    extends GetLikesUsersByPostState {
  const GetLikesUsersByPostNoInternetConnectionState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetLikesUsersByPostLoadedState extends GetLikesUsersByPostState {
  const GetLikesUsersByPostLoadedState(
      {required super.users, required super.page, required super.canLoadMore});
}

final class GetLikesUsersByPostErrorState extends GetLikesUsersByPostState {
  final String message;

  const GetLikesUsersByPostErrorState(
      {required this.message,
      required super.users,
      required super.page,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, users, page, canLoadMore];
}
