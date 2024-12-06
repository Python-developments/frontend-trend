import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/widgets/logo_loader.dart';
import '../../../../core/widgets/my_error_widget.dart';
import '../../../../core/widgets/no_internet_connection_widget.dart';
import '../../../../core/widgets/users_list_widget.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../bloc/get_profile_followers_bloc/get_profile_followers_bloc.dart';

class ProfileFollowersPage extends StatefulWidget {
  final int profileId;
  const ProfileFollowersPage({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ProfileFollowersPage> createState() => _ProfileFollowersPageState();
}

class _ProfileFollowersPageState extends State<ProfileFollowersPage> {
  late PaginationParam _paginationParams;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  void _getAllGetProfileFollowers() {
    context.read<GetProfileFollowersBloc>().add(FetchProfileFollowersEvent(
        params: (_paginationParams..page = 1), profileId: widget.profileId));
  }

  void _fetchGetProfileFollowersNextPage() {
    final bloc = context.read<GetProfileFollowersBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(FetchProfileFollowersEvent(
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
    _getAllGetProfileFollowers();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final offset = _scrollController.offset;
      final outOfRange = _scrollController.position.outOfRange;
      if (offset >= maxScrollExtent && !outOfRange) {
        _fetchGetProfileFollowersNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Followers".hardcoded),
      ),
      body: BlocConsumer<GetProfileFollowersBloc, GetProfileFollowersState>(
        listener: (context, state) {
          if (state is GetProfileFollowersNoInternetConnectionState) {
            ToastUtils(context).showNoInternetConnectionToast();
          } else if (state is GetProfileFollowersErrorState) {
            ToastUtils(context).showCustomToast(message: state.message);
          }
        },
        builder: (context, state) {
          if (state is GetProfileFollowersLoadedState ||
              state.users.isNotEmpty) {
            bool isLoadingMore = (page != 1 &&
                state.canLoadMore &&
                (context.read<GetProfileFollowersBloc>().isLoading));
            return UsersListWidget(
                scrollController: _scrollController,
                profiles: state.users,
                isLoadingMore: isLoadingMore);
          } else if (state is GetProfileFollowersErrorState) {
            return MyErrorWidget(
                message: state.message, onRetry: _getAllGetProfileFollowers);
          } else if (state is GetProfileFollowersNoInternetConnectionState) {
            return NoInternetConnectionWidget(
                onRetry: _getAllGetProfileFollowers);
          }
          return const Center(
            child: LogoLoader(),
          );
        },
      ),
    );
  }
}
