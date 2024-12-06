import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:frontend_trend/features/authentication/data/models/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/repository_handler.dart';
import '../../../../core/utils/shared_pref.dart';
import '../data_source/auth_remote_data_source.dart';
import '../models/register_form_data.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final SharedPref sharedPref;
  final NetworkInfo networkInfo;
  final RepositoryHandler repositoryHandler;

  AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.networkInfo,
    required this.sharedPref,
    required this.repositoryHandler,
  });

  @override
  Future<Either<Failure, Unit>> login(String username, String password) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          final user = await authRemoteDataSource.login(username, password);
          log("user avatar from auth reposotory is ${user.avatar}");
          sharedPref.login(user);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> register(RegisterFormData formData) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          await authRemoteDataSource.register(formData);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> forgetPassword(String email) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          await authRemoteDataSource.forgetPassword(email);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> checkCode(
      {required String email, required String code}) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          await authRemoteDataSource.checkCode(email: email, code: code);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> confirmForgetPassword(
      {required String email,
      required String code,
      required String newPassword}) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          await authRemoteDataSource.confirmForgetPassword(
              email: email, code: code, newPassword: newPassword);
          return unit;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }
}
