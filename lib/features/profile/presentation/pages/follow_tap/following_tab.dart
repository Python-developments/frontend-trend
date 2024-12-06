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
import 'package:frontend_trend/features/profile/presentation/bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/pages/profile_page.dart';
import 'package:frontend_trend/injection_container.dart';

class FolowingTab extends StatefulWidget {
  final int profileId;
  final Function function;
  const FolowingTab(
      {super.key, required this.profileId, required this.function});
  @override
  State<FolowingTab> createState() => _FolowingTabState();
}

class _FolowingTabState extends State<FolowingTab> {
  bool isCurrentUser = false;
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
    isCurrentUser = sl<SharedPref>().account!.profileId == widget.profileId;
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
    // TODO: implement build
    return BlocConsumer<GetProfileFollowingBloc, GetProfileFollowingState>(
        listener: (context, state) {
      if (state is GetProfileFollowingNoInternetConnectionState) {
        ToastUtils(context).showNoInternetConnectionToast();
      } else if (state is GetProfileFollowingErrorState) {
        ToastUtils(context).showCustomToast(message: state.message);
      }
    }, builder: (context, state) {
      if (state is GetProfileFollowingLoadedState || state.users.isNotEmpty) {
        return Center(
          child: state.users.isEmpty
              ? Text("No Body Follow you yet")
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
                          imageUrl: state.users[index].avatar,
                          size: 35,
                        ),
                      ),
                      title: Text(
                        state.users[index].username,
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600),
                      ),
                      trailing: isCurrentUser
                          ? InkWell(
                              onTap: () {
                                context.read<ProfileBloc>().add(ToggleFollowEv(
                                    otherUserId: state.users[index].id,
                                    isFollow: !state.users[index].isFollowing,
                                    context: context));
                                widget.function(true);
                              },
                              child: Container(
                                height: 25.h,
                                width: 70.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 226, 17, 17),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text('Unfollow',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : SizedBox.shrink(),
                    );
                  },
                ),
        );
      } else if (state is GetProfileFollowingErrorState) {
        return MyErrorWidget(
            message: state.message, onRetry: _getAllGetProfileFollowing);
      } else if (state is GetProfileFollowingNoInternetConnectionState) {
        return NoInternetConnectionWidget(onRetry: _getAllGetProfileFollowing);
      }
      return const Center(
        child: LogoLoader(),
      );
    });
  }
}
