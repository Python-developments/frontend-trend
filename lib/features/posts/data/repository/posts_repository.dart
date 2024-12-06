import 'package:dartz/dartz.dart';
import '../models/comment_model.dart';
import '../models/params/add_comment_params.dart';
import '../models/params/add_post_params.dart';
import '../models/post_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/entities/pagination_param.dart';

abstract class PostsRepository {
  // posts
  Future<Either<Failure, PagedList<PostModel>>> getAllPosts(
      PaginationParam params);
  Future<Either<Failure, PostModel>> getPostDetails(int postId);
  Future<Either<Failure, Unit>> addPost(AddPostParams params);
  Future<Either<Failure, bool>> toggleLike(int postId);
  Future<Either<Failure, PostModel>> toggleReaction(
      int postId, String reactionType);
  Future<Either<Failure, Unit>> deletePost(int postId);
  Future<Either<Failure, Unit>> hidePost(int postId);

  // comments
  Future<Either<Failure, PagedList<CommentModel>>> getCommentsByPost(
      int postId, PaginationParam params);
  Future<Either<Failure, Unit>> addComment(AddCommentParams params);

  // likes
  Future<Either<Failure, PagedList<ProfileModel>>> getLikesUsersByPost(
      int postId, PaginationParam params);
}
