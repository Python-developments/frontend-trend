part of 'vlogs_bloc.dart';

sealed class VlogsState extends Equatable {
  final List<VlogModel> vlogs;
  final VlogModel? currentVlog;
  final int? page;
  final bool canLoadMore;

  const VlogsState(
      {required this.vlogs,
      required this.page,
      required this.canLoadMore,
      required this.currentVlog});
  @override
  List<Object?> get props => [identityHashCode(this)];
}

final class VlogsInitialState extends VlogsState {
  const VlogsInitialState(
      {super.vlogs = const [],
      super.page = 1,
      super.canLoadMore = true,
      super.currentVlog});
}

final class VlogsLoadingState extends VlogsState {
  const VlogsLoadingState(
      {required super.vlogs,
      required super.page,
      required super.canLoadMore,
      required super.currentVlog});
}

final class VlogsNoInternetConnectionState extends VlogsState {
  const VlogsNoInternetConnectionState(
      {required super.vlogs,
      required super.page,
      required super.canLoadMore,
      required super.currentVlog});
}

final class VlogAddedSuccessState extends VlogsState {
  const VlogAddedSuccessState(
      {required super.vlogs,
      required super.page,
      required super.canLoadMore,
      required super.currentVlog});
}

final class VlogDeletedSuccessState extends VlogsState {
  const VlogDeletedSuccessState(
      {required super.vlogs,
      required super.page,
      required super.canLoadMore,
      required super.currentVlog});
}

final class VlogsLoadedState extends VlogsState {
  const VlogsLoadedState(
      {required super.vlogs,
      required super.page,
      required super.canLoadMore,
      required super.currentVlog});
}

final class VlogsErrorState extends VlogsState {
  final String message;

  const VlogsErrorState(
      {required this.message,
      required super.vlogs,
      required super.page,
      required super.currentVlog,
      required super.canLoadMore});

  @override
  List<Object?> get props => [message, vlogs, page, canLoadMore, currentVlog];
}
