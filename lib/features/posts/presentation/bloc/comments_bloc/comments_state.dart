part of 'comments_bloc.dart';

sealed class CommentsState extends Equatable {
  final List<CommentModel> comments;
  final int? page;
  final bool canLoadMore;

  const CommentsState(
      {required this.comments, required this.page, required this.canLoadMore});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class CommentsInitialState extends CommentsState {
  const CommentsInitialState({
    super.comments = const [],
    super.page = 1,
    super.canLoadMore = true,
  });
}

final class CommentsLoadingState extends CommentsState {
  const CommentsLoadingState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class CommentsNoInternetConnectionState extends CommentsState {
  const CommentsNoInternetConnectionState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class CommentAddedSuccessState extends CommentsState {
  const CommentAddedSuccessState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class CommentsLoadedState extends CommentsState {
  const CommentsLoadedState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class CommentsErrorState extends CommentsState {
  final String message;

  const CommentsErrorState(
      {required this.message,
      required super.comments,
      required super.page,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, comments, page, canLoadMore];
}
