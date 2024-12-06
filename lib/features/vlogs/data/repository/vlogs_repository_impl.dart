import 'package:dartz/dartz.dart';
import '../models/params/add_vlog_params.dart';
import '../models/vlog_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/repositories/repository_handler.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/utils/shared_pref.dart';
import '../data_source/vlogs_remote_data_source.dart';
import '../models/params/add_vlog_comment_params.dart';
import '../models/vlog_comment_model.dart';
import 'vlogs_repository.dart';

class VlogsRepositoryImpl implements VlogsRepository {
  final VlogsRemoteDataSource vlogsRemoteDataSource;
  final SharedPref sharedPref;
  final NetworkInfo networkInfo;
  final RepositoryHandler repositoryHandler;

  VlogsRepositoryImpl({
    required this.vlogsRemoteDataSource,
    required this.networkInfo,
    required this.sharedPref,
    required this.repositoryHandler,
  });

  @override
  Future<Either<Failure, PagedList<VlogModel>>> getAllVlogs(
      PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<VlogModel>>(
        () async {
          final vlogs = await vlogsRemoteDataSource.getAllVlogs(params);
          return vlogs;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<VlogCommentModel>>> getCommentsByVlog(
      int vlogId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<VlogCommentModel>>(
        () async {
          final comments =
              await vlogsRemoteDataSource.getCommentsByVlog(vlogId, params);
          return comments;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addVlog(AddVlogParams params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await vlogsRemoteDataSource.addVlog(params);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addComment(AddVlogCommentParams params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await vlogsRemoteDataSource.addComment(params);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteVlog(int vlogId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<Unit>(
        () async {
          return await vlogsRemoteDataSource.deleteVlog(vlogId);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> toggleLike(int vlogId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<bool>(
        () async {
          return await vlogsRemoteDataSource.toggleLike(vlogId);
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, VlogModel>> getVlogDetails(int vlogId) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<VlogModel>(
        () async {
          final vlog = await vlogsRemoteDataSource.getVlogDetails(vlogId);
          return vlog;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, PagedList<VlogModel>>> getProfileVlogs(
      int profileId, PaginationParam params) async {
    if (await networkInfo.isConnected) {
      return repositoryHandler.handle<PagedList<VlogModel>>(
        () async {
          final vlogs =
              await vlogsRemoteDataSource.getProfileVlogs(profileId, params);
          return vlogs;
        },
      );
    } else {
      return Left(NoInternetConnectionFailure());
    }
  }
}
