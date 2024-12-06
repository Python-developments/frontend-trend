part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class GetCommentsByPostEvent extends CommentsEvent {
  final PaginationParam params;
  final int postId;
  final bool emitLoading;
  final bool scrollToBottom;

  const GetCommentsByPostEvent(
      {required this.params,
      required this.postId,
      this.emitLoading = true,
      this.scrollToBottom = false});

  @override
  List<Object> get props => [params, postId];
}

class AddCommentEvent extends CommentsEvent {
  final AddCommentParams params;
  final bool emitLoading;
  final BuildContext context;

  const AddCommentEvent(
      {required this.context, required this.params, this.emitLoading = true});

  @override
  List<Object> get props => [params];
}
