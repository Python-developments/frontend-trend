part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoadedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class CheckCodeEv extends AuthEvent {
  final String email;
  final String code;

  const CheckCodeEv({required this.email, required this.code});
}

class ConfirmForgetPasswordEv extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;

  const ConfirmForgetPasswordEv({
    required this.email,
    required this.code,
    required this.newPassword,
  });
}
