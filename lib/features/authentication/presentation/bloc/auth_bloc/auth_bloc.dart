import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../data/models/register_form_data.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authRepository,
  }) : super(AuthInitial()) {
    on<LoginEv>(_onLoginEvent);
    on<RegisterEv>(_onRegisterEvent);
    on<ForgetPasswordEv>(_onForgetPasswordEvent);
    on<CheckCodeEv>(_onCheckCodeEvent);
    on<ConfirmForgetPasswordEv>(_onConfirmForgetPasswordEvent);
  }

  final AuthRepository authRepository;

  FutureOr<void> _onForgetPasswordEvent(
      ForgetPasswordEv event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final failureOrSuccess = await authRepository.forgetPassword(event.email);
    emit(failureOrSuccess.fold(
      (failure) => _mapFailureToState(failure),
      (_) => AuthLoadedState(),
    ));
  }

  FutureOr<void> _onLoginEvent(LoginEv event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    // await Future.delayed(Duration(seconds: 2));
    // emit(AuthLoadedState());
    final failureOrSuccess =
        await authRepository.login(event.username, event.password);

    emit(failureOrSuccess.fold(
      (failure) => _mapFailureToState(failure),
      (_) => AuthLoadedState(),
    ));
  }

  FutureOr<void> _onRegisterEvent(
      RegisterEv event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final failureOrSuccess = await authRepository.register(event.formData);
    emit(failureOrSuccess.fold(
      (failure) => _mapFailureToState(failure),
      (_) => AuthLoadedState(),
    ));
  }

  FutureOr<void> _onCheckCodeEvent(
      CheckCodeEv event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final failureOrSuccess = await authRepository.checkCode(
      email: event.email,
      code: event.code,
    );
    emit(failureOrSuccess.fold(
      (failure) => _mapFailureToState(failure),
      (_) => AuthLoadedState(),
    ));
  }

  FutureOr<void> _onConfirmForgetPasswordEvent(
      ConfirmForgetPasswordEv event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final failureOrSuccess = await authRepository.confirmForgetPassword(
      email: event.email,
      code: event.code,
      newPassword: event.newPassword,
    );

    emit(failureOrSuccess.fold(
      (failure) => _mapFailureToState(failure),
      (_) => AuthLoadedState(),
    ));
  }

  AuthState _mapFailureToState(Failure failure) {
    if (failure is ServerFailure) {
      return const AuthErrorState(message: AppStrings.someThingWentWrong);
    }

    if (failure is MessageFailure) {
      return AuthErrorState(message: failure.message);
    }

    return const AuthErrorState(message: AppStrings.someThingWentWrong);
  }
}
