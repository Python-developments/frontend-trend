import 'package:dartz/dartz.dart';
import '../models/profile_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/entities/paged_list.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../models/profile_form_data.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileModel>> getUserProfile(
      int profileId, PaginationParam params);
  Future<Either<Failure, ProfileModel>> editUserProfile(
      ProfileFormData formData);
  Future<Either<Failure, bool>> toggleFollow(int otherUserId, bool isFollow);
  Future<Either<Failure, Unit>> blockUser(int blockedUserId);
  Future<Either<Failure, Unit>> unblockUser(int blockedUserId);
  Future<Either<Failure, PagedList<ProfileModel>>> getBlockList();

  Future<Either<Failure, PagedList<ProfileModel>>> getProfileFollowers(
      int profileId, PaginationParam params);

  Future<Either<Failure, PagedList<ProfileModel>>> getProfileFollowing(
      int profileId, PaginationParam params);
}
