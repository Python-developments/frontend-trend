import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/utils/entities/pagination_param.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/core/widgets/logo_loader.dart';
import 'package:frontend_trend/core/widgets/my_error_widget.dart';
import 'package:frontend_trend/core/widgets/no_internet_connection_widget.dart';
import 'package:frontend_trend/features/chat/chat_user.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/get_profile_followers_bloc/get_profile_followers_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/pages/profile_page.dart';
import 'package:frontend_trend/injection_container.dart';

class FollowerTab extends StatefulWidget {
  final int profileId;
  FollowerTab({required this.profileId});
  @override
  State<FollowerTab> createState() => _FollowerTabState();
}

class _FollowerTabState extends State<FollowerTab> {
  bool isCurrentUser = false;
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
    isCurrentUser = sl<SharedPref>().account!.profileId == widget.profileId;
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
    // TODO: implement build
    return BlocConsumer<GetProfileFollowersBloc, GetProfileFollowersState>(
        listener: (context, state) {
      if (state is GetProfileFollowersNoInternetConnectionState) {
        ToastUtils(context).showNoInternetConnectionToast();
      } else if (state is GetProfileFollowersErrorState) {
        ToastUtils(context).showCustomToast(message: state.message);
      }
    }, builder: (context, state) {
      if (state is GetProfileFollowersLoadedState || state.users.isNotEmpty) {
        return Center(
          child: state.users.isEmpty
              ? Text("You didnt follow any users")
              : ListView.builder(
                  itemCount: state.users.length, // Replace with dynamic count
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: GestureDetector(
                          onTap: () {
                            Get.to(BlocProvider(
                                create: (context) => sl<ProfileBloc>(),
                                child: ProfilePage(
                                    profileId: state.users[index].id)));
                          },
                          child: CustomCachedImageWidget(
                              size: 40, imageUrl: state.users[index].avatar)),
                      title: Text(
                        state.users[index].username,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600),
                      ),
                      trailing: state.users[index].id ==
                              sl<SharedPref>().account!.profileId
                          ? SizedBox.shrink()
                          : InkWell(
                              onTap: () {
                                Get.to(ChatUser());
                              },
                              child: Container(
                                height: 25.h,
                                width: 70.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Message',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                    );
                  },
                ),
        );
      } else if (state is GetProfileFollowersErrorState) {
        return MyErrorWidget(
            message: state.message, onRetry: _getAllGetProfileFollowers);
      } else if (state is GetProfileFollowersNoInternetConnectionState) {
        return NoInternetConnectionWidget(onRetry: _getAllGetProfileFollowers);
      }
      return const Center(
        child: LogoLoader(),
      );
    });
  }
}
