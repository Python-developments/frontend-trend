part of 'vlogs_bloc.dart';

abstract class VlogsEvent extends Equatable {
  const VlogsEvent();

  @override
  List<Object?> get props => [];
}

class GetProfileVlogsEvent extends VlogsEvent {
  final int profileId;
  final PaginationParam params;
  final bool emitLoading;

  const GetProfileVlogsEvent(
      {required this.profileId, required this.params, this.emitLoading = true});

  @override
  List<Object?> get props => [params, emitLoading];
}

class GetAllVlogsEvent extends VlogsEvent {
  final PaginationParam params;
  final bool emitLoading;

  const GetAllVlogsEvent({required this.params, this.emitLoading = true});

  @override
  List<Object?> get props => [params, emitLoading];
}

class AddVlogEvent extends VlogsEvent {
  final AddVlogParams params;

  const AddVlogEvent({required this.params});

  @override
  List<Object?> get props => [params];
}

class DeleteVlogEvent extends VlogsEvent {
  final int vlogId;

  const DeleteVlogEvent({required this.vlogId});

  @override
  List<Object?> get props => [vlogId];
}

class ToggleLikeEvent extends VlogsEvent {
  final VlogModel vlog;

  const ToggleLikeEvent({required this.vlog});

  @override
  List<Object?> get props => [vlog];
}

class FetchSingleVlogEvent extends VlogsEvent {
  final int vlogId;

  const FetchSingleVlogEvent({required this.vlogId});

  @override
  List<Object?> get props => [vlogId];
}

class UpdateCommentsCountForVlogEvent extends VlogsEvent {
  final bool isIncrease;
  final int vlogId;

  const UpdateCommentsCountForVlogEvent(
      {required this.isIncrease, required this.vlogId});

  @override
  List<Object?> get props => [isIncrease, vlogId];
}
