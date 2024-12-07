part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object?> get props => [];
}

class GetAllPostsEvent extends PostsEvent {
  final PaginationParam params;
  final bool emitLoading;

  const GetAllPostsEvent({required this.params, this.emitLoading = true});

  @override
  List<Object?> get props => [params, emitLoading];
}

class GetUserPostsEvent extends PostsEvent {
  final PaginationParam params;
  final bool emitLoading;
  final int userId;
  final List<PostModel> posts;

  const GetUserPostsEvent(
      {required this.params,
      this.emitLoading = true,
      required this.posts,
      required this.userId});

  @override
  List<Object?> get props => [params, emitLoading];
}

class AddPostEvent extends PostsEvent {
  final AddPostParams params;

  const AddPostEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeletePostEvent extends PostsEvent {
  final int postId;

  const DeletePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class HidePostEvent extends PostsEvent {
  final int postId;

  const HidePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class ToggleLikeEvent extends PostsEvent {
  final PostModel post;

  const ToggleLikeEvent({required this.post});

  @override
  List<Object?> get props => [post];
}

class ToggleReactionEvent extends PostsEvent {
  final PostModel post;
  final UserModel? user;
  final String reactionType;
  const ToggleReactionEvent(
      {required this.post, required this.reactionType, required this.user});
}

class ToggleLocalReactionEvent extends PostsEvent {
  final List<PostModel> posts;
  final PostModel post;
  final UserModel? user;
  final String reactionType;
  const ToggleLocalReactionEvent(
      {required this.posts,
      required this.post,
      required this.reactionType,
      required this.user});
}

class InitialocalReactionEvent extends PostsEvent {
  final List<PostModel> posts;
  final UserModel? user;
  const InitialocalReactionEvent({required this.posts, required this.user});
}

class FetchSinglePostEvent extends PostsEvent {
  final int postId;

  const FetchSinglePostEvent({required this.postId});

  @override
  List<Object?> get props => [postId];
}

class UpdateCommentsCountForPostEvent extends PostsEvent {
  final bool isIncrease;
  final int postId;

  const UpdateCommentsCountForPostEvent(
      {required this.isIncrease, required this.postId});

  @override
  List<Object?> get props => [isIncrease, postId];
}
