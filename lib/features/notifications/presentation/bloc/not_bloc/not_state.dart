part of 'not_bloc.dart';

sealed class NotState extends Equatable {
  final List<NotificationModel> nots;

  const NotState({required this.nots});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class NotsInitialState extends NotState {
  const NotsInitialState({
    super.nots = const [],
  });
}

final class NotsLoadingState extends NotState {
  const NotsLoadingState({
    required super.nots,
  });
}

final class NotsNoInternetConnectionState extends NotState {
  const NotsNoInternetConnectionState({
    required super.nots,
  });
}

final class NotsAddedSuccessState extends NotState {
  const NotsAddedSuccessState({
    required super.nots,
  });
}

final class NotsLoadedState extends NotState {
  const NotsLoadedState({
    required super.nots,
  });
}

final class NotsErrorState extends NotState {
  final String message;

  const NotsErrorState({
    required this.message,
    required super.nots,
  });

  @override
  List<Object?> get props => [message, nots];
}
