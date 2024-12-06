import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../models/profile_form_data.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getUserProfile(int profileId, PaginationParam params);
  Future<ProfileModel> editUserProfile(ProfileFormData formData);
  Future<bool> toggleFollow(int otherUserId, bool isFollow);
  Future<PagedList<ProfileModel>> getProfileFollowers(
      int profileId, PaginationParam params);
  Future<PagedList<ProfileModel>> getProfileFollowing(
      int profileId, PaginationParam params);
  Future<Unit> blockUser(int blockedUserId);
  Future<Unit> unBlockUser(int blockedUserId);
  Future<PagedList<ProfileModel>> blockList();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;
  ProfileRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ProfileModel> editUserProfile(ProfileFormData formData) async {
    Map<String, dynamic> body = {
      "bio": formData.bio,
      "first_name": formData.fName,
      "last_name": formData.lName,
      "phone_number": formData.phone,
      "location": formData.location,
    };

    if (formData.backgroundImage != null &&
        formData.backgroundImage?.path != null) {
      body.addAll({
        "background_pic": [
          await MultipartFile.fromFile(formData.backgroundImage!.path)
        ]
      });
    }
    if (formData.avatar != null && formData.avatar?.path != null) {
      body.addAll({
        "avatar": [await MultipartFile.fromFile(formData.avatar!.path)]
      });
    }
    log("profile bio is $body");
    final response =
        await apiConsumer.patch(EndPoints.editProfile(formData.profileId),
            formDataIsEnabled: true,
            body: body
            // {
            //   "bio": "gaza",
            //   "first_name": "test fname",
            //   "last_name": "test lname",
            //   "phone_number": "test phone",
            //   "location": "test location"
            // }
            ,
            queryParameters: {});
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<ProfileModel> getUserProfile(
      int profileId, PaginationParam params) async {
    final response = await apiConsumer.get("${EndPoints.profile}$profileId/",
        queryParameters: {"p": params.page});

    if (response.statusCode == 200) {
      return ProfileModel.fromJson(response.data);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<bool> toggleFollow(int otherUserId, bool isFollow) async {
    if (isFollow) {
      final response = await apiConsumer
          .post(EndPoints.followUser, formDataIsEnabled: true, body: {
        "following_id": otherUserId,
      });
      if (response.statusCode == 201) {
        return true;
      } else {
        throw const ServerException();
      }
    } else {
      final response = await apiConsumer.delete(
          "${EndPoints.unFollowUser}$otherUserId/",
          formDataIsEnabled: true);

      if (response.statusCode == 204) {
        return false;
      } else {
        throw const ServerException();
      }
    }
  }

  @override
  Future<PagedList<ProfileModel>> getProfileFollowers(
      int profileId, PaginationParam params) async {
    final response = await apiConsumer.get(
        EndPoints.profileFollowers(profileId),
        queryParameters: {"p": params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);

      final List<ProfileModel> users = (response.data['results'] as List)
          .map((jsonUser) => ProfileModel.fromJson(jsonUser))
          .toList();
      return PagedList(nextPageNumber: nextPage, items: users);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PagedList<ProfileModel>> getProfileFollowing(
      int profileId, PaginationParam params) async {
    final response = await apiConsumer.get(
        EndPoints.profileFollowing(profileId),
        queryParameters: {"p": params.page});
    if (response.statusCode == 200) {
      final int? nextPage = getPageNumberFromUrl(response.data["next"]);

      final List<ProfileModel> users = (response.data['results'] as List)
          .map((jsonUser) => ProfileModel.fromJson(jsonUser))
          .toList();
      return PagedList(nextPageNumber: nextPage, items: users);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> blockUser(int blockedUserId) async {
    final response = await apiConsumer.post(
      EndPoints.blockUser,
      body: {
        "blocked_id": blockedUserId,
      },
    );
    if (response.statusCode == 201 && response.data["success"]) {
      return unit;
    } else if (response.statusCode == 400 &&
        !response.data["success"] &&
        response.data['message'] != null) {
      throw MessageException(message: response.data['message']);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<PagedList<ProfileModel>> blockList() async {
    // TODO: implement blockList
    final response = await apiConsumer.get(
      EndPoints.blockList,
    );
    log("the blocklist response is ${response.data}");
    if (response.statusCode < 300 && response.data["success"]) {
      List<dynamic> data = response.data["data"];
      List<ProfileModel> profilesData = data.map((x) {
        ProfileModel profileModel = ProfileModel.fromJson(x["blocked_profile"]);
        return profileModel;
      }).toList();
      return PagedList(nextPageNumber: 1, items: profilesData);
    } else if (response.statusCode == 400 &&
        !response.data["success"] &&
        response.data['message'] != null) {
      throw MessageException(message: response.data['message']);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> unBlockUser(int blockedUserId) async {
    // TODO: implement unBlockUser
    final response = await apiConsumer.delete(
      EndPoints.unBlockUser(blockedUserId),
    );
    if (response.statusCode < 300) {
      return unit;
    } else if (response.statusCode == 400 &&
        !response.data["success"] &&
        response.data['message'] != null) {
      throw MessageException(message: response.data['message']);
    } else {
      throw const ServerException();
    }
  }
}
