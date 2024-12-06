import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/shared_pref.dart';
import '../models/not_model.dart';
import '../../../profile/data/models/profile_model.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/api/generate_response_error_message.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/entities/pagination_param.dart';

abstract class NotificationsRemoteDataSource {
  //posts
  Future<PagedList<NotificationModel>> getAllNotifications();
}

class NotsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiConsumer apiConsumer;
  final SharedPref sharedPref;
  NotsRemoteDataSourceImpl({
    required this.apiConsumer,
    required this.sharedPref,
  });

  @override
  Future<PagedList<NotificationModel>> getAllNotifications() async {
    final response = await apiConsumer.get(
      EndPoints.notifications,
    );
    if (response.statusCode == 200) {
      final List<NotificationModel> posts =
          (response.data['results']['notifications'] as List)
              .map((jsonPost) => NotificationModel.fromJson(jsonPost))
              .toList();

      return PagedList(nextPageNumber: 1, items: posts);
    } else {
      throw const ServerException();
    }
  }
}
