import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/generate_response_error_message.dart';
import '../../../../core/error/exceptions.dart';
import '../models/register_form_data.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(
    String email,
    String password,
  );
  Future<Unit> register(RegisterFormData formData);
  Future<Unit> forgetPassword(String email);
  Future<Unit> checkCode({required String email, required String code});
  Future<Unit> confirmForgetPassword(
      {required String email,
      required String code,
      required String newPassword});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;
  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await apiConsumer.post(EndPoints.login, body: {
      "username": username,
      "password": password,
    });
    log(response.data.toString());
    if (response.statusCode == 200) {
      final UserModel user = UserModel.fromJson(response.data);

      return Future.value(user);
    } else if (response.statusCode == 401) {
      throw MessageException(message: response.data['detail']);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> register(RegisterFormData formData) async {
    final response = await apiConsumer.post(EndPoints.register, body: {
      "username": formData.username,
      "email": formData.email,
      "password": formData.password,
      "password2": formData.password,
      "avatar_key": "a"
    });
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else if (response.statusCode == 400) {
      final errorMessage = generateResponseErrorMessage(response.data);
      throw MessageException(message: errorMessage);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> forgetPassword(String email) async {
    final response = await apiConsumer.post(EndPoints.forgetPassword, body: {
      "email": email,
    });

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw MessageException(message: response.data["message"]);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> checkCode({required String email, required String code}) async {
    final response = await apiConsumer.post(EndPoints.checkCode, body: {
      "email": email,
      "code": code,
    });

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else if (response.statusCode == 400) {
      throw MessageException(
          message: response.data["message"]["non_field_errors"][0]);
    } else {
      throw const ServerException();
    }
  }

  @override
  Future<Unit> confirmForgetPassword(
      {required String email,
      required String code,
      required String newPassword}) async {
    final response = await apiConsumer.post(EndPoints.confirmPassword, body: {
      "email": email,
      "code": code,
      "new_password": newPassword,
    });

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else if (response.statusCode == 400) {
      final errorMessage =
          generateResponseErrorMessage(response.data['message']);
      throw MessageException(message: errorMessage);
    } else {
      throw const ServerException();
    }
  }
}
