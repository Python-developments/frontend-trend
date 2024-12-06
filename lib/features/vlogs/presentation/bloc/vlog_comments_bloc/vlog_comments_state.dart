part of 'vlog_comments_bloc.dart';

sealed class VlogCommentsState extends Equatable {
  final List<VlogCommentModel> comments;
  final int? page;
  final bool canLoadMore;

  const VlogCommentsState(
      {required this.comments, required this.page, required this.canLoadMore});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class VlogCommentsInitialState extends VlogCommentsState {
  const VlogCommentsInitialState({
    super.comments = const [],
    super.page = 1,
    super.canLoadMore = true,
  });
}

final class VlogCommentsLoadingState extends VlogCommentsState {
  const VlogCommentsLoadingState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class VlogCommentsNoInternetConnectionState extends VlogCommentsState {
  const VlogCommentsNoInternetConnectionState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class CommentAddedSuccessState extends VlogCommentsState {
  const CommentAddedSuccessState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class VlogCommentsLoadedState extends VlogCommentsState {
  const VlogCommentsLoadedState(
      {required super.comments,
      required super.page,
      required super.canLoadMore});
}

final class VlogCommentsErrorState extends VlogCommentsState {
  final String message;

  const VlogCommentsErrorState(
      {required this.message,
      required super.comments,
      required super.page,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, comments, page, canLoadMore];
}
