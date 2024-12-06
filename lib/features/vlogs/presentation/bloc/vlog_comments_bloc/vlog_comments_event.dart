part of 'vlog_comments_bloc.dart';

abstract class VlogCommentsEvent extends Equatable {
  const VlogCommentsEvent();

  @override
  List<Object> get props => [];
}

class GetCommentsByVlogEvent extends VlogCommentsEvent {
  final PaginationParam params;
  final int vlogId;
  final bool emitLoading;
  final bool scrollToBottom;

  const GetCommentsByVlogEvent(
      {required this.params,
      required this.vlogId,
      this.emitLoading = true,
      this.scrollToBottom = false});

  @override
  List<Object> get props => [params, vlogId];
}

class AddCommentEvent extends VlogCommentsEvent {
  final AddVlogCommentParams params;
  final bool emitLoading;
  final BuildContext context;
  final VlogsBloc vlogsVloc;

  const AddCommentEvent(
      {required this.vlogsVloc,required this.context, required this.params, this.emitLoading = true});

  @override
  List<Object> get props => [params];
}
