import 'package:dartz/dartz.dart';
import '../models/comment_model.dart';
import '../models/params/add_comment_params.dart';
import '../models/params/add_post_params.dart';
import '../models/post_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/repository_handler.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/utils/shared_pref.dart';
import '../data_source/posts_remote_data_source.dart';
import 'posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource postsRemoteDataSource;
  final SharedPref sharedPref;
  final NetworkInfo networkInfo;
  final RepositoryHandler repositoryHandler;

  PostsRepositoryImpl({
    required this.postsRemoteDataSource,
    required this.networkInfo,
    required this.sharedPref,
    required this.repositoryHandler,
  });

  @override
  Future<Either<Failure, PagedList<PostModel>>> getAllPosts(
      PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<PostModel>>(
        () async {
          final posts = await postsRemoteDataSource.getAllPosts(params);
          return posts;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<CommentModel>>> getCommentsByPost(
      int postId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<CommentModel>>(
        () async {
          final comments =
              await postsRemoteDataSource.getCommentsByPost(postId, params);
          return comments;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(AddPostParams params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await postsRemoteDataSource.addPost(params);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addComment(AddCommentParams params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await postsRemoteDataSource.addComment(params);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await postsRemoteDataSource.deletePost(postId);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleLike(int postId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<bool>(
        () async {
          return await postsRemoteDataSource.toggleLike(postId);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> getPostDetails(int postId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PostModel>(
        () async {
          final post = await postsRemoteDataSource.getPostDetails(postId);
          return post;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<ProfileModel>>> getLikesUsersByPost(
      int postId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<ProfileModel>>(
        () async {
          final users =
              await postsRemoteDataSource.getLikesUsersByPost(postId, params);
          return users;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> hidePost(int postId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await postsRemoteDataSource.hidePost(postId);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PostModel>> toggleReaction(
      int postId, String reactionType) async {
    // TODO: implement toggleReaction
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PostModel>(
        () async {
          return await postsRemoteDataSource.toggleReaction(
              postId, reactionType);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }
}
