import 'package:dartz/dartz.dart';
import '../models/not_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/repository_handler.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/shared_pref.dart';
import '../data_source/nots_remote_data_source.dart';
import 'nots_repository.dart';

class NotsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource postsRemoteDataSource;
  final SharedPref sharedPref;
  final NetworkInfo networkInfo;
  final RepositoryHandler repositoryHandler;

  NotsRepositoryImpl({
    required this.postsRemoteDataSource,
    required this.networkInfo,
    required this.sharedPref,
    required this.repositoryHandler,
  });

  @override
  Future<Either<Failure, PagedList<NotificationModel>>>
      getAllNotifications() async {
    // TODO: implement getAllNotifications
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<NotificationModel>>(
        () async {
          final posts = await postsRemoteDataSource.getAllNotifications();
          return posts;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }
}
