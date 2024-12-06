part of 'current_user_cubit.dart';

class CurrentUserState extends Equatable {
  final UserModel? user;
  const CurrentUserState({
    required this.user,
  });

  @override
  List<Object> get props => [identityHashCode(this)];
}
