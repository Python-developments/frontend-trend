// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'end_points.dart';

class AppIntercepters extends Interceptor {
  final SharedPref sharedPref;
  final Dio client;

  AppIntercepters({required this.sharedPref, required this.client});
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // options.headers[AppStrings.contentType] = AppStrings.applicationJson;
    // options.headers[AppStrings.lng] = langLocalDataSource.getSavedLang();

    try {
      final token = sharedPref.account?.accessToken;
      log(token.toString());
      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    } catch (_) {}
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    if (err.response?.statusCode == 401) {
      try {
        final token = sharedPref.account?.refreshToken ?? "";
        if (await _refreshToken(token)) {
          return handler.resolve(await _retry(err.requestOptions));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
    super.onError(err, handler);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options =
        Options(method: requestOptions.method, headers: requestOptions.headers);
    return client.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> _refreshToken(String oldToken) async {
    final dio = Dio();

    Map<String, dynamic>? headers = {};
    final response = await dio.post(
      EndPoints.baseUrl + EndPoints.refreshToken,
      data: {"refresh": oldToken},
      options: Options(headers: headers),
    );

    if (response.statusCode == 200) {
      final newAccount = sharedPref.account!.copyWith(
          accessToken: response.data['access'],
          refreshToken: response.data['refresh']);

      // sharedPref.login(newAccount);

      return true;
    } else {
      return false;
    }
  }
}
