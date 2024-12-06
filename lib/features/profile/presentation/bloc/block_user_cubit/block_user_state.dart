part of 'block_user_cubit.dart';

sealed class BlockUserState extends Equatable {
  const BlockUserState();
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class BlockUserInitialState extends BlockUserState {}

final class BlockUserLoadingState extends BlockUserState {}

final class BlockListLoadingState extends BlockUserState {}

final class BlockListLoadedState extends BlockUserState {
  final PagedList<ProfileModel> users;
  BlockListLoadedState(this.users);
}

final class BlockUserNoInternetConnectionState extends BlockUserState {}

final class BlockUserSuccessState extends BlockUserState {}

final class BlockUserErrorState extends BlockUserState {
  final String message;

  const BlockUserErrorState({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
