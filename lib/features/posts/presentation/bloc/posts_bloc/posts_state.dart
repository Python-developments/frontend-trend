part of 'posts_bloc.dart';

sealed class PostsState extends Equatable {
  final List<PostModel> posts;
  final PostModel? currentPost;
  final int? page;
  final bool canLoadMore;

  const PostsState(
      {required this.posts,
      required this.page,
      required this.canLoadMore,
      required this.currentPost});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class PostsInitialState extends PostsState {
  const PostsInitialState(
      {super.posts = const [],
      super.page = 1,
      super.canLoadMore = true,
      super.currentPost});
}

final class PostsLoadingState extends PostsState {
  const PostsLoadingState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class PostsNoInternetConnectionState extends PostsState {
  const PostsNoInternetConnectionState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class PostAddedSuccessState extends PostsState {
  const PostAddedSuccessState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class PostDeletedSuccessState extends PostsState {
  const PostDeletedSuccessState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class PostHidedSuccessState extends PostsState {
  const PostHidedSuccessState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class HidePostLoadingState extends PostsState {
  const HidePostLoadingState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class PostsLoadedState extends PostsState {
  const PostsLoadedState(
      {required super.posts,
      required super.page,
      required super.canLoadMore,
      required super.currentPost});
}

final class PostsErrorState extends PostsState {
  final String message;

  const PostsErrorState(
      {required this.message,
      required super.posts,
      required super.page,
      required super.currentPost,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, posts, page, canLoadMore, currentPost];
}
