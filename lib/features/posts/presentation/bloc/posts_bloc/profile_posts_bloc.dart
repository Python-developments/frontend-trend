import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_trend/features/posts/data/models/post_model.dart';
import 'package:frontend_trend/features/posts/data/repository/posts_repository.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:path/path.dart';

class ProfilePostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  ProfilePostsBloc({required this.postsRepository})
      : super(ProfilePostsLoadedState(
            canLoadMore: false, posts: [], page: 1, currentPost: null)) {
    on<ToggleLocalReactionEvent>(_onToggleLocalReactionEvent);
    on<InitialocalReactionEvent>(_onInitialLocalReactionEvent);
  }
  FutureOr<void> _onInitialLocalReactionEvent(
      InitialocalReactionEvent event, Emitter<PostsState> emit) async {
    emit(ProfilePostsLoadedState(
      posts: event.posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: event.posts[0],
    ));
  }

  FutureOr<void> _onToggleLocalReactionEvent(
      ToggleLocalReactionEvent event, Emitter<PostsState> emit) async {
    List<PostModel> posts = event.posts;
    PostModel currentPost = event.post;
    String newReaction = event.reactionType;
    final index = posts.indexWhere((p) => p.id == currentPost.id);
    log(index.toString());

    if (index == -1) {
      return; // Post not found, nothing to update
    }

    // Get the current post

    PostModel post = posts[index];
    log(post.userReaction?.toString() ?? 'null');
    if (post.userReaction == null) {
      post.userReaction = newReaction;
      post.totalReactionsCount += 1;
    } else {
      post.userReaction = null;
      post.totalReactionsCount -= 1;
    }
    log(post.userReaction?.toString() ?? 'null');
    posts[index] = post;
    emit(ProfilePostsLoadedState(
      posts: posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: currentPost,
    ));

    event.context.read<PostsBloc>().add(ToggleReactionEvent(
        post: event.post, reactionType: event.reactionType, user: event.user));
  }
}
