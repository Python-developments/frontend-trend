import 'package:dartz/dartz.dart';
import '../models/vlog_comment_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../models/params/add_vlog_comment_params.dart';
import '../models/params/add_vlog_params.dart';
import '../models/vlog_model.dart';

abstract class VlogsRepository {
  // Vlogs
  Future<Either<Failure, PagedList<VlogModel>>> getAllVlogs(
      PaginationParam params);
  Future<Either<Failure, PagedList<VlogModel>>> getProfileVlogs(
      int profileId, PaginationParam params);
      
  Future<Either<Failure, VlogModel>> getVlogDetails(int vlogId);
  Future<Either<Failure, Unit>> addVlog(AddVlogParams params);
  Future<Either<Failure, bool>> toggleLike(int vlogId);
  Future<Either<Failure, Unit>> deleteVlog(int vlogId);

  // comments
  Future<Either<Failure, PagedList<VlogCommentModel>>> getCommentsByVlog(
      int vlogId, PaginationParam params);
  Future<Either<Failure, Unit>> addComment(AddVlogCommentParams params);
}
