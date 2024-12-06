import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../models/register_form_data.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> login(
    String username,
    String password,
  );
  Future<Either<Failure, Unit>> register(RegisterFormData formData);
  Future<Either<Failure, Unit>> forgetPassword(String email);
  Future<Either<Failure, Unit>> checkCode(
      {required String email, required String code});
  Future<Either<Failure, Unit>> confirmForgetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
