part of 'get_profile_following_bloc.dart';

sealed class GetProfileFollowingEvent extends Equatable {
  const GetProfileFollowingEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileFollowingEvent extends GetProfileFollowingEvent {
  final PaginationParam params;
  final int profileId;
  final bool emitLoading;

  const FetchProfileFollowingEvent({
    required this.params,
    required this.profileId,
    this.emitLoading = true,
  });

  @override
  List<Object> get props => [params, profileId];
}
