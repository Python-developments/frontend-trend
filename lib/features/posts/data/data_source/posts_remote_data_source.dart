import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/shared_pref.dart';
import '../models/comment_model.dart';
import '../models/params/add_comment_params.dart';
import '../models/params/add_post_params.dart';
import '../models/post_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/generate_response_error_message.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/entities/pagination_param.dart';

abstract class PostsRemoteDataSource {
  //posts
  Future<PagedList<PostModel>> getAllPosts(PaginationParam params);
  Future<PostModel> getPostDetails(int postId);
  Future<Unit> addPost(AddPostParams params);
  Future<bool> toggleLike(int postId);
  Future<PostModel> toggleReaction(int postId, String type);
  Future<Unit> deletePost(int postId);
  Future<Unit> hidePost(int postId);

  //comments
  Future<PagedList<CommentModel>> getCommentsByPost(
      int postId, PaginationParam params);
  Future<Unit> addComment(AddCommentParams params);

  // likes
  Future<PagedList<ProfileModel>> getLikesUsersByPost(
      int postId, PaginationParam params);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiConsumer apiConsumer;
  final SharedPref sharedPref;
  PostsRemoteDataSourceImpl({
    required this.apiConsumer,
    required this.sharedPref,
  });

  @override
  Future<PagedList<PostModel>> getAllPosts(PaginationParam params) async {
    final response = await apiConsumer.get(EndPoints.posts, queryParameters: {
      'p': params.page,
    });
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);
      final List<PostModel> posts = (response.data['results'] as List)
          .map((jsonPost) => PostModel.fromJson(jsonPost))
          .toList();

      return PagedList(nextPageNumber: nextPage, items: posts);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PagedList<CommentModel>> getCommentsByPost(
      int postId, PaginationParam params) async {
    final response = await apiConsumer.get(
        "${EndPoints.baseUrl}/post/$postId/comments/",
        queryParameters: {"p": params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);

      final List<CommentModel> comments = (response.data['results'] as List)
          .map((jsonComment) => CommentModel.fromJson(jsonComment))
          .toList();
      return PagedList(nextPageNumber: nextPage, items: comments);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> addPost(AddPostParams params) async {
    final response = await apiConsumer
        .post(EndPoints.addPost, formDataIsEnabled: true, body: {
      'image': [await MultipartFile.fromFile(params.imageFile.path)],
      'username': sharedPref.account!.id,
      'content': params.description
    });
    if (response.statusCode == 201) {
      return unit;
    } else if (response.statusCode == 400) {
      final errorMessage = generateResponseErrorMessage(response.data, true);
      throw MessageException(message: errorMessage);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> addComment(AddCommentParams params) async {
    final response = await apiConsumer.post(EndPoints.addComment, body: {
      'user': sharedPref.account!.id,
      'post': params.postId,
      'content': params.comment,
    });
    if (response.statusCode == 201) {
      return unit;
    } else if (response.statusCode == 400) {
      final errorMessage = generateResponseErrorMessage(response.data);
      throw MessageException(message: errorMessage);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final response = await apiConsumer.delete(EndPoints.deletePost(postId));
    if (response.statusCode == 204) {
      return unit;
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<bool> toggleLike(int postId) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await apiConsumer.post(EndPoints.toggleLike, body: {
      "post_id": postId,
      "user_id": sharedPref.account!.id,
    });
    if (response.statusCode == 200) {
      return response.data['liked'];
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PostModel> getPostDetails(int postId) async {
    final response = await apiConsumer.get(
      "${EndPoints.postDetails}$postId/",
    );
    if (response.statusCode == 200) {
      return PostModel.fromJson(response.data);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PagedList<ProfileModel>> getLikesUsersByPost(
      int postId, PaginationParam params) async {
    final response = await apiConsumer
        .get(EndPoints.postLikers(postId), queryParameters: {"p": params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);

      final List<ProfileModel> users = (response.data['results'] as List)
          .map((jsonUser) => ProfileModel.fromJson(jsonUser['profile']))
          .toList();
      return PagedList(nextPageNumber: nextPage, items: users);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> hidePost(int postId) async {
    final response = await apiConsumer.post(EndPoints.hidePost, body: {
      "post_id": postId,
    });
    if (response.statusCode == 201 && response.data['success']) {
      return unit;
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PostModel> toggleReaction(int id, String type) async {
    // TODO: implement toggleReaction
    await Future.delayed(const Duration(seconds: 2));
    final response = await apiConsumer
        .post(EndPoints.toggleReaction(id), body: {"reaction_type": type});
    if (response.statusCode < 300) {
      return PostModel.fromJson(response.data);
    } else {
      throw const ServerException();
    }
  }
}
