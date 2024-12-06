import 'package:dartz/dartz.dart';
import '../models/not_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/entities/paged_list.dart';

abstract class NotificationsRepository {
  // posts
  Future<Either<Failure, PagedList<NotificationModel>>> getAllNotifications();
}
