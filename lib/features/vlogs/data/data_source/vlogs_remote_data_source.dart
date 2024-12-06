import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/shared_pref.dart';
import '../models/vlog_comment_model.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/generate_response_error_message.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../vlogs/data/models/params/add_vlog_params.dart';
import '../models/params/add_vlog_comment_params.dart';
import '../models/vlog_model.dart';

abstract class VlogsRemoteDataSource {
  //vlogs
  Future<PagedList<VlogModel>> getAllVlogs(PaginationParam params);
  Future<PagedList<VlogModel>> getProfileVlogs(
      int profileId, PaginationParam params);
  Future<VlogModel> getVlogDetails(int vlogId);
  Future<Unit> addVlog(AddVlogParams params);
  Future<bool> toggleLike(int vlogId);
  Future<Unit> deleteVlog(int vlogId);

  //comments
  Future<PagedList<VlogCommentModel>> getCommentsByVlog(
      int vlogId, PaginationParam params);
  Future<Unit> addComment(AddVlogCommentParams params);
}

class VlogsRemoteDataSourceImpl implements VlogsRemoteDataSource {
  final ApiConsumer apiConsumer;
  final SharedPref sharedPref;
  VlogsRemoteDataSourceImpl({
    required this.apiConsumer,
    required this.sharedPref,
  });

  @override
  Future<PagedList<VlogModel>> getAllVlogs(PaginationParam params) async {
    final response = await apiConsumer
        .get(EndPoints.vlogs, queryParameters: {'p': params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);
      final List<VlogModel> vlogs = (response.data['results'] as List)
          .map((jsonVlog) => VlogModel.fromJson(jsonVlog))
          .toList();

      return PagedList(nextPageNumber: nextPage, items: vlogs);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PagedList<VlogCommentModel>> getCommentsByVlog(
      int vlogId, PaginationParam params) async {
    final response = await apiConsumer.get(
        "${EndPoints.baseUrl}/videos/$vlogId/comments/",
        queryParameters: {"page": params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);

      final List<VlogCommentModel> comments = (response.data['results'] as List)
          .map((jsonComment) => VlogCommentModel.fromJson(jsonComment))
          .toList();
      return PagedList(nextPageNumber: nextPage, items: comments);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> addVlog(AddVlogParams params) async {
    final response = await apiConsumer
        .post(EndPoints.addVlog, formDataIsEnabled: true, body: {
      'video': [await MultipartFile.fromFile(params.videoFile.path)],
      'description': params.description,
      'title': params.description,
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
  Future<Unit> addComment(AddVlogCommentParams params) async {
    final response =
        await apiConsumer.post(EndPoints.addVlogComment(params.vlogId), body: {
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
  Future<Unit> deleteVlog(int vlogId) async {
    final response =
        await apiConsumer.delete("${EndPoints.vlogs}${vlogId.toString()}/");
    if (response.statusCode == 204) {
      return unit;
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<bool> toggleLike(int vlogId) async {
    await Future.delayed(const Duration(seconds: 2));
    final response =
        await apiConsumer.post(EndPoints.toggleVlogLike(vlogId), body: {
      "video_id": vlogId,
    });
    if (response.statusCode == 200) {
      return response.data['liked'];
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<VlogModel> getVlogDetails(int vlogId) async {
    final response = await apiConsumer.get(
      "${EndPoints.vlogs}$vlogId/",
    );
    if (response.statusCode == 200) {
      return VlogModel.fromJson(response.data);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PagedList<VlogModel>> getProfileVlogs(
      int profileId, PaginationParam params) async {
    final response = await apiConsumer.get(EndPoints.profileVlogs(profileId),
        queryParameters: {'p': params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);
      final List<VlogModel> vlogs = (response.data['results'] as List)
          .map((jsonVlog) => VlogModel.fromJson(jsonVlog))
          .toList();

      return PagedList(nextPageNumber: nextPage, items: vlogs);
    } else {
      throw const ServerException();
    }
  }
}
