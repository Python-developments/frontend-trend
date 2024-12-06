part of 'not_bloc.dart';

abstract class NotEvent extends Equatable {
  const NotEvent();

  @override
  List<Object?> get props => [];
}

class GetAllNotsEvent extends NotEvent {
  final bool emitLoading;

  const GetAllNotsEvent({this.emitLoading = true});

  @override
  List<Object?> get props => [emitLoading];
}
