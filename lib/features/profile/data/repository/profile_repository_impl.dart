import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../models/profile_form_data.dart';
import '../models/profile_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/repository_handler.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/utils/shared_pref.dart';
import '../data_source/profile_remote_data_source.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource profileRemoteDataSource;
  final SharedPref sharedPref;
  final NetworkInfo networkInfo;
  final RepositoryHandler repositoryHandler;

  ProfileRepositoryImpl({
    required this.profileRemoteDataSource,
    required this.networkInfo,
    required this.sharedPref,
    required this.repositoryHandler,
  });

  @override
  Future<Either<Failure, ProfileModel>> editUserProfile(
      ProfileFormData formData) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<ProfileModel>(
        () async {
          final profile =
              await profileRemoteDataSource.editUserProfile(formData);
          return profile;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> getUserProfile(
      int profileId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<ProfileModel>(
        () async {
          final profile =
              await profileRemoteDataSource.getUserProfile(profileId, params);
          // sharedPref.login(user);

          return profile;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFollow(
      int otherUserId, bool isFollow) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<bool>(
        () async {
          final isFollowing =
              await profileRemoteDataSource.toggleFollow(otherUserId, isFollow);
          return isFollowing;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<ProfileModel>>> getProfileFollowers(
      int profileId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<ProfileModel>>(
        () async {
          final users = await profileRemoteDataSource.getProfileFollowers(
              profileId, params);
          return users;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<ProfileModel>>> getProfileFollowing(
      int profileId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<ProfileModel>>(
        () async {
          final users = await profileRemoteDataSource.getProfileFollowing(
              profileId, params);
          return users;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> blockUser(int blockedUserId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          await profileRemoteDataSource.blockUser(blockedUserId);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<ProfileModel>>> getBlockList() async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<ProfileModel>>(
        () async {
          final users = await profileRemoteDataSource.blockList();
          return users;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> unblockUser(int blockedUserId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          await profileRemoteDataSource.unBlockUser(blockedUserId);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }
}
