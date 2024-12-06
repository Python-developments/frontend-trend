part of 'get_likes_users_by_post_bloc.dart';

sealed class GetLikesUsersByPostEvent extends Equatable {
  const GetLikesUsersByPostEvent();

  @override
  List<Object> get props => [];
}

class FetchLikesUsersByPostEvent extends GetLikesUsersByPostEvent {
  final PaginationParam params;
  final int postId;
  final bool emitLoading;

  const FetchLikesUsersByPostEvent({
    required this.params,
    required this.postId,
    this.emitLoading = true,
  });

  @override
  List<Object> get props => [params, postId];
}
