import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:frontend_trend/features/authentication/data/models/user_model.dart';
import '../../../data/repository/posts_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../data/models/params/add_post_params.dart';
import '../../../data/models/post_model.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository postsRepository;
  PostsBloc({required this.postsRepository})
      : super(const PostsInitialState()) {
    on<GetAllPostsEvent>(
      _onGetAllPostsEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
    on<GetUserPostsEvent>(
      _onGetUserPostsEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
    on<AddPostEvent>(_onAddPostEvent);
    on<DeletePostEvent>(_onDeletePostEvent);
    on<HidePostEvent>(_onHidePostEvent);
    on<ToggleLikeEvent>(_onToggleLikeEvent);
    on<ToggleReactionEvent>(_onToggleReactionEvent);
    on<FetchSinglePostEvent>(_onFetchSinglePostEvent);
    on<UpdateCommentsCountForPostEvent>(_onUpdateCommentsCountForPostEvent);
  }
  bool isLoading = false;
  EventTransformer<PostsEvent> _debounceAndSwitch<PostsEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  FutureOr<void> _onGetAllPostsEvent(
      GetAllPostsEvent event, Emitter<PostsState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(PostsLoadingState(
        posts: event.params.page == 1 ? const [] : state.posts,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
        currentPost: state.currentPost,
      ));
    }
    final failureOrPosts = await postsRepository.getAllPosts(event.params);
    emit(failureOrPosts.fold(
      (failure) => _mapFailureToState(failure),
      (postsPagedList) {
        return PostsLoadedState(
          posts: event.params.page != 1
              ? (List.of(state.posts)..addAll(postsPagedList.items))
              : postsPagedList.items,
          page: event.params.page,
          canLoadMore: postsPagedList.nextPageNumber != null,
          currentPost: state.currentPost,
        );
      },
    ));
    isLoading = false;
  }

  FutureOr<void> _onGetUserPostsEvent(
      GetUserPostsEvent event, Emitter<PostsState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(PostsLoadingState(
        posts: event.posts,
        page: event.params.page == 1 ? 1 : state.page,
        canLoadMore: event.params.page == 1 ? true : state.canLoadMore,
        currentPost: state.currentPost,
      ));
    }
    final failureOrPosts = await postsRepository.getAllPosts(event.params);
    emit(failureOrPosts.fold(
      (failure) => _mapFailureToState(failure),
      (postsPagedList) {
        return PostsLoadedState(
          posts: event.params.page != 1
              ? (List.of(state.posts)..addAll(postsPagedList.items))
              : postsPagedList.items,
          page: event.params.page,
          canLoadMore: postsPagedList.nextPageNumber != null,
          currentPost: state.currentPost,
        );
      },
    ));
    isLoading = false;
  }

  FutureOr<void> _onAddPostEvent(
      AddPostEvent event, Emitter<PostsState> emit) async {
    emit(PostsLoadingState(
      posts: state.posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: state.currentPost,
    ));

    final result = await postsRepository.addPost(event.params);

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        emit(PostAddedSuccessState(
            posts: state.posts,
            page: state.page,
            currentPost: state.currentPost,
            canLoadMore: state.canLoadMore));
        add(GetAllPostsEvent(params: PaginationParam(page: 1)));
      },
    );
  }

  FutureOr<void> _onDeletePostEvent(
      DeletePostEvent event, Emitter<PostsState> emit) async {
    emit(PostsLoadingState(
      posts: state.posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: state.currentPost,
    ));
    final result = await postsRepository.deletePost(event.postId);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        final posts = state.posts
          ..removeWhere((element) => element.id == event.postId);
        emit(PostDeletedSuccessState(
          posts: posts,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentPost: state.currentPost,
        ));
        emit(PostsLoadedState(
          posts: posts,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentPost: state.currentPost,
        ));
      },
    );
  }

  PostModel _updateTopReactions(PostModel post) {
    // Sort reactions by count (in descending order)
    if (post.reactionList.length == 0) {
      post.topReactions = [];
    } else {
      post.reactionListCount.sort((a, b) => (b.count).compareTo(a.count));

      // Keep only the top 3 reactions
      post.topReactions = post.reactionListCount.take(3).toList();
    }

    // Return the updated post
    return post;
  }

  FutureOr<void> _onToggleReactionEvent(
      ToggleReactionEvent event, Emitter<PostsState> emit) async {
    log(state.posts.length.toString());
    List<PostModel> posts = state.posts;
    PostModel currentPost = event.post;
    String newReaction = event.reactionType;
    final index = posts.indexWhere((p) => p.id == currentPost.id);

    if (index == -1) {
      return; // Post not found, nothing to update
    }

    // Get the current post
    PostModel post = posts[index];

    if (post.userReaction == null) {
      // Case 1: If user_reaction is null, assign the new reaction type
      post.userReaction = newReaction;
      post.totalReactionsCount += 1;

      // Add the new reaction to reactionList and reactionListCount
      post.reactionList.add(ReactionModel.fromJson({
        'user': event.user?.username,
        'reaction_type': newReaction,
      }));

      // Update reactionListCount for the new reaction type
      bool reactionFound = false;
      for (var reaction in post.reactionListCount) {
        if (reaction.reactionType == newReaction) {
          reaction.count = (reaction.count) + 1;
          reactionFound = true;
          break;
        }
      }

      if (!reactionFound) {
        post.reactionListCount.add(ReactionModel.fromJson({
          'reaction_type': newReaction,
          'count': 1,
        }));
      }

      // Update topReactions (Top 3 reactions by count)
      post = _updateTopReactions(post); // Recalculate and update topReactions
    } else if (event.reactionType == "remove") {
      log("removed removed");
      // Case 2: If user_reaction is "remove", reset the reaction
      String? oldUserReaction = event.post.userReaction;
      log("old reaction is $oldUserReaction");
      post.userReaction = null;
      post.totalReactionsCount -= 1;

      // Remove the reaction from reactionList and reactionListCount

      post.reactionList
          .removeWhere((reaction) => reaction.userName == event.user?.username);
      int reactionIndex = post.reactionListCount.indexWhere(
        (reaction) => reaction.reactionType == oldUserReaction,
      );
      log("===========" + post.reactionListCount.join(',') + "=========");
      if (reactionIndex != -1) {
        if (post.reactionListCount[reactionIndex].count == 1) {
          log("reaction index is " + reactionIndex.toString() + "=========");

          post.reactionListCount.removeAt(reactionIndex);
        } else {
          --post.reactionListCount[reactionIndex].count;
        }
      }
      log("===========" + post.reactionListCount.join(',') + "=========");

      post = _updateTopReactions(post); // Recalculate and update topReactions
    } else if (post.userReaction == newReaction) {
      log("here i am");
      // Case 3: If user_reaction is the same as the received reactionType, do nothing
      return;
    } else {
      log("status 4");
      // Case 4: If user_reaction is different, update to the new reaction
      String oldReaction = post.userReaction ?? '';
      String newReaction = event.reactionType;

      // Update user reaction to the new one
      post.userReaction = newReaction;

      // Remove the old reaction from reactionList and reactionListCount

      post.reactionList
          .removeWhere((reaction) => reaction.userName == event.user);
      int reactionIndex = post.reactionListCount.indexWhere(
        (reaction) => reaction.reactionType == oldReaction,
      );
      log("===========" + post.reactionListCount.join(',') + "=========");
      if (reactionIndex != -1) {
        if (post.reactionListCount[reactionIndex].count == 1) {
          post.reactionListCount.removeAt(reactionIndex);
        } else {
          --post.reactionListCount[reactionIndex].count;
        }
      }
      int newReactionIndex = post.reactionListCount.indexWhere(
        (reaction) => reaction.reactionType == event.reactionType,
      );

      if (newReactionIndex != -1) {
        ++post.reactionListCount[newReactionIndex].count;
      } else {
        post.reactionListCount.add(ReactionModel(
            count: 1,
            reactionType: event.reactionType,
            userName: event.user?.username));
      }
      // Add the new reaction
      post.reactionList.add(ReactionModel.fromJson({
        'user': event.user?.username,
        'reaction_type': newReaction,
      }));

      // Update reactionListCount for the new reaction type

      // Recalculate topReactions after the change
      post = _updateTopReactions(post); // Recalculate and update topReactions
    }

    // After modifying the post, update the posts list
    posts[index] = post;

    // Emit the new state with updated posts list

    /*
    ReactionModel reactionModel = ReactionModel.fromJson(
        {"user": event.user?.username, "reaction_type": event.reactionType});
    bool userReactBefore =
        reactionList.any((item) => item.userName == reactionModel.userName);
    if (userReactBefore) {
      bool userAndReactExistBefore = reactionList.any((item) {
        return ((item.reactionType!.trim() == reactionModel.reactionType));
      });
      reactionList
          .removeWhere((item) => item.userName == reactionModel.userName);
      if (!userAndReactExistBefore) {
        reactionList.add(reactionModel);
      } else {
        --reactsCount;
      }
    } else {
      reactionList.add(reactionModel);
      ++reactsCount;
    }

    PostModel? currentPost = event.post.id == state.currentPost?.id
        ? state.currentPost!.copyWith(
            topReactions: reactionList, totalReactionsCount: reactsCount)
        : state.currentPost;
   
    posts[index] = posts[index]
        .copyWith(topReactions: reactionList, totalReactionsCount: reactsCount);

    emit(PostsLoadedState(
      posts: posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: currentPost,
    ));
*/
    emit(PostsLoadedState(
      posts: posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: currentPost,
    ));
    // emit(PostsLoadingState(
    //   posts: posts,
    //   page: state.page,
    //   canLoadMore: state.canLoadMore,
    //   currentPost: currentPost,
    // ));
    // emit(PostsLoadedState(posts: posts));
    // emit(PostsLoadedState(
    //   posts: posts,
    //   page: state.page,
    //   canLoadMore: state.canLoadMore,
    //   currentPost: post,
    // ));

    final postOrFailure =
        await postsRepository.toggleReaction(event.post.id, event.reactionType);

    /*postOrFailure.fold(
      (failure) {
        posts[index] = event.post;

        emit(PostsLoadedState(
          posts: posts,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentPost: event.post,
        ));
      },
      (newPost) {
        posts[index] = newPost;

        emit(PostsLoadedState(
          posts: posts,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentPost: newPost,
        ));
      },
    );*/
  }

  FutureOr<void> _onToggleLikeEvent(
      ToggleLikeEvent event, Emitter<PostsState> emit) async {
    List<PostModel> posts = state.posts;
    PostModel? currentPost = event.post.id == state.currentPost?.id
        ? state.currentPost!.copyWith(
            likedByUser: !state.currentPost!.likedByUser,
            likeCount: state.currentPost!.likedByUser
                ? state.currentPost!.likeCount - 1
                : state.currentPost!.likeCount + 1)
        : state.currentPost;
    final index = posts.indexWhere((p) => p.id == event.post.id);
    posts
      ..removeAt(index)
      ..insert(
          index,
          event.post.copyWith(
            likedByUser: !event.post.likedByUser,
            likeCount: event.post.likedByUser
                ? event.post.likeCount - 1
                : event.post.likeCount + 1,
          ));

    currentPost = event.post.id == state.currentPost?.id
        ? state.currentPost!.copyWith(
            likedByUser: !state.currentPost!.likedByUser,
            likeCount: state.currentPost!.likedByUser
                ? state.currentPost!.likeCount - 1
                : state.currentPost!.likeCount + 1)
        : state.currentPost;

    emit(PostsLoadingState(
      posts: posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: currentPost,
    ));
    // emit(PostsLoadedState(posts: posts));
    final result = await postsRepository.toggleLike(event.post.id);
    result.fold(
      (failure) {
        posts
          ..removeAt(index)
          ..insert(
              index,
              event.post.copyWith(
                likedByUser: event.post.likedByUser,
                likeCount: event.post.likeCount,
              ));
        currentPost = event.post.id == state.currentPost?.id
            ? state.currentPost!.copyWith(
                likedByUser: !state.currentPost!.likedByUser,
                likeCount: state.currentPost!.likedByUser
                    ? state.currentPost!.likeCount + 1
                    : state.currentPost!.likeCount - 1)
            : state.currentPost;
        // emit(PostsLoadedState(
        //   posts: posts,
        //   page: state.page,
        //   canLoadMore: state.canLoadMore,
        //   currentPost: currentPost,
        // ));
      },
      (likedByUser) {
        posts
          ..removeAt(index)
          ..insert(
              index,
              event.post.copyWith(
                likedByUser: likedByUser,
                likeCount: likedByUser
                    ? event.post.likeCount + 1
                    : event.post.likeCount - 1,
              ));
      },
    );

    // emit(PostsLoadedState(
    //   posts: posts,
    //   page: state.page,
    //   canLoadMore: state.canLoadMore,
    //   currentPost: currentPost,
    // ));
  }

  PostsState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return PostsErrorState(
          message: (failure).message,
          posts: state.posts,
          page: state.page,
          currentPost: state.currentPost,
          canLoadMore: state.canLoadMore);
    } else if (failure is NoInternetConnectionFailure) {
      return PostsNoInternetConnectionState(
        posts: state.posts,
        page: state.page,
        canLoadMore: state.canLoadMore,
        currentPost: state.currentPost,
      );
    } else {
      return PostsErrorState(
          posts: state.posts,
          message: AppStrings.someThingWentWrong,
          page: state.page,
          currentPost: state.currentPost,
          canLoadMore: state.canLoadMore);
    }
  }

  FutureOr<void> _onFetchSinglePostEvent(
      FetchSinglePostEvent event, Emitter<PostsState> emit) async {
    emit(PostsLoadingState(
      posts: state.posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: state.currentPost,
    ));

    final postOrFailure = await postsRepository.getPostDetails(event.postId);
    emit(postOrFailure.fold(
        (failure) => _mapFailureToState(failure),
        (post) => PostsLoadedState(
              posts: state.posts,
              page: state.page,
              canLoadMore: state.canLoadMore,
              currentPost: post,
            )));
  }

  FutureOr<void> _onUpdateCommentsCountForPostEvent(
      UpdateCommentsCountForPostEvent event, Emitter<PostsState> emit) {
    final newPosts = state.posts
        .map((p) => p.id == event.postId
            ? p.copyWith(
                commentCount:
                    event.isIncrease ? ++p.commentCount : --p.commentCount)
            : p)
        .toList();
    final currentPost =
        state.currentPost != null && state.currentPost?.id == event.postId
            ? state.currentPost?.copyWith(
                commentCount: event.isIncrease
                    ? ++state.currentPost!.commentCount
                    : --state.currentPost!.commentCount)
            : state.currentPost;
    emit(PostsLoadedState(
      posts: newPosts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: currentPost,
    ));
  }

  FutureOr<void> _onHidePostEvent(
      HidePostEvent event, Emitter<PostsState> emit) async {
    emit(HidePostLoadingState(
      posts: state.posts,
      page: state.page,
      canLoadMore: state.canLoadMore,
      currentPost: state.currentPost,
    ));
    final result = await postsRepository.hidePost(event.postId);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        final posts = state.posts
          ..removeWhere((element) => element.id == event.postId);
        emit(PostHidedSuccessState(
          posts: posts,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentPost: state.currentPost,
        ));
        emit(PostsLoadedState(
          posts: posts,
          page: state.page,
          canLoadMore: state.canLoadMore,
          currentPost: state.currentPost,
        ));
      },
    );
  }
}
