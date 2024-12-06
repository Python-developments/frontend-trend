part of 'get_profile_followers_bloc.dart';

sealed class GetProfileFollowersEvent extends Equatable {
  const GetProfileFollowersEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileFollowersEvent extends GetProfileFollowersEvent {
  final PaginationParam params;
  final int profileId;
  final bool emitLoading;

  const FetchProfileFollowersEvent({
    required this.params,
    required this.profileId,
    this.emitLoading = true,
  });

  @override
  List<Object> get props => [params, profileId];
}
