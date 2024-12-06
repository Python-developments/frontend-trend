import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';
import '../../../../core/widgets/users_list_widget.dart';
import '../bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import '../../../../core/utils/entities/pagination_param.dart';

class ProfileFollowingPage extends StatefulWidget {
  final int profileId;
  const ProfileFollowingPage({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ProfileFollowingPage> createState() => _ProfileFollowingPageState();
}

class _ProfileFollowingPageState extends State<ProfileFollowingPage> {
  late PaginationParam _paginationParams;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _getAllGetProfileFollowing() {
    context.read<GetProfileFollowingBloc>().add(FetchProfileFollowingEvent(
        params: (_paginationParams..page = 1), profileId: widget.profileId));
  }

  void _fetchGetProfileFollowingNextPage() {
    final bloc = context.read<GetProfileFollowingBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(FetchProfileFollowingEvent(
          params: _paginationParams..page = _paginationParams.page + 1,
          profileId: widget.profileId));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    _getAllGetProfileFollowing();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final offset = _scrollController.offset;
      final outOfRange = _scrollController.position.outOfRange;
      if (offset >= maxScrollExtent && !outOfRange) {
        _fetchGetProfileFollowingNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Following".hardcoded),
      ),
      body: BlocConsumer<GetProfileFollowingBloc, GetProfileFollowingState>(
        listener: (context, state) {
          if (state is GetProfileFollowingNoInternetConnectionState) {
            ToastUtils(context).showNoInternetConnectionToast();
          } else if (state is GetProfileFollowingErrorState) {
            ToastUtils(context).showCustomToast(message: state.message);
          }
        },
        builder: (context, state) {
          if (state is GetProfileFollowingLoadedState ||
              state.users.isNotEmpty) {
            bool isLoadingMore = (page != 1 &&
                state.canLoadMore &&
                (context.read<GetProfileFollowingBloc>().isLoading));
            return UsersListWidget(
                scrollController: _scrollController,
                profiles: state.users,
                isLoadingMore: isLoadingMore);
          } else if (state is GetProfileFollowingErrorState) {
            return MyErrorWidget(
                message: state.message, onRetry: _getAllGetProfileFollowing);
          } else if (state is GetProfileFollowingNoInternetConnectionState) {
            return NoInternetConnectionWidget(
                onRetry: _getAllGetProfileFollowing);
          }
          return const Center(
            child: LogoLoader(),
          );
        },
      ),
    );
  }
}
