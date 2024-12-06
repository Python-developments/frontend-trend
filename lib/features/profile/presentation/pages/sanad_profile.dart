import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/utils/entities/pagination_param.dart';
import 'package:frontend_trend/core/utils/shared_pref.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/features/chat/list_users.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/get_profile_followers_bloc/get_profile_followers_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/pages/edit_profile.dart';
import 'package:frontend_trend/features/profile/presentation/pages/follow_tap/follow_tap.dart';
import 'package:frontend_trend/features/profile/presentation/pages/profile_page.dart';
import 'package:frontend_trend/features/profile/presentation/widgets/profile_posts.dart';
import 'package:frontend_trend/injection_container.dart';

class SanadProfile extends StatefulWidget {
  final int profileId;

  const SanadProfile({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<SanadProfile> createState() => _SanadProfileState();
}

class _SanadProfileState extends State<SanadProfile> {
  bool isCurrentUser = false;
  late PaginationParam _paginationParams;
  final ScrollController _scrollController = ScrollController();
  int _selectedTab = 0;

  @override
  void didUpdateWidget(covariant SanadProfile oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.profileId != oldWidget.profileId) {
      isCurrentUser = sl<SharedPref>().account!.profileId == widget.profileId;
      _fetchProfileInfo();
    }
  }

  @override
  void initState() {
    super.initState();
    isCurrentUser = sl<SharedPref>().account!.profileId == widget.profileId;
    _paginationParams = PaginationParam(page: 1);
    if (widget.profileId != context.read<ProfileBloc>().state.profile?.id) {
      _fetchProfileInfo();
    }
  }

  void _fetchProfileInfo() {
    context.read<ProfileBloc>().add(FetchProfileInfoEv(
          profileId: widget.profileId,
          params: PaginationParam(page: 1),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _fetchProfileInfo();
    // TODO: implement build
    return BlocConsumer<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is ProfileNoInternetConnectionState) {
        ToastUtils(context).showNoInternetConnectionToast();
      } else if (state is ProfileErrorState) {
        ToastUtils(context).showCustomToast(
          message: state.message,
          iconData: Icons.error_outline,
        );
      }
    }, builder: (context, state) {
      log("---------------------------------------------------");
      return state.profile == null
          ? SizedBox(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45.r,
                    child: CustomCachedImageWidget(
                        size: 90.h, imageUrl: state.profile?.avatar ?? ''),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Scout Organizations',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '@${state.profile?.username}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color.fromARGB(255, 141, 141, 141),
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 25.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              state.profile?.postsCount.toString() ?? '-',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Posts',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) =>
                                        sl<GetProfileFollowersBloc>()),
                                BlocProvider(
                                    create: (context) =>
                                        sl<GetProfileFollowingBloc>()),
                                BlocProvider(
                                    create: (context) => sl<ProfileBloc>()),
                              ],
                              child: FollowTabs(
                                profileId: state.profile?.id ?? 0,
                                name: state.profile?.username ?? '',
                                tabIndex: 0,
                              ),
                            ));
                          },
                          child: Column(
                            children: [
                              Text(
                                state.profile?.followersCount.toString() ?? '-',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Followers',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            bool x = await Get.to(MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) =>
                                        sl<GetProfileFollowersBloc>()),
                                BlocProvider(
                                    create: (context) =>
                                        sl<GetProfileFollowingBloc>()),
                              ],
                              child: FollowTabs(
                                profileId: state.profile?.id ?? 0,
                                name: state.profile?.username ?? '',
                                tabIndex: 1,
                              ),
                            ));
                            if (x) {
                              _fetchProfileInfo();
                            }
                          },
                          child: Column(
                            children: [
                              Text(
                                state.profile?.followingCount.toString() ?? '-',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Following',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              state.profile?.reactionCount.toString() ?? '0',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Likes',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.h),
                  !isCurrentUser
                      ? Row(
                          children: [
                            SizedBox(width: 30.w),
                            Expanded(
                              child: InkWell(
                                onTap: state is ProfileFollowLoadingState
                                    ? null
                                    : () {
                                        context.read<ProfileBloc>().add(
                                            ToggleFollowEv(
                                                otherUserId: widget.profileId,
                                                isFollow:
                                                    !state.profile!.isFollowing,
                                                context: context));
                                      },
                                child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(7.r),
                                        color: Colors.black),
                                    height: 28.h,
                                    child: state is ProfileFollowLoadingState
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            state.profile!.isFollowing
                                                ? "Following".hardcoded
                                                : "Follow".hardcoded,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          )),
                              ),
                            ),
                            /*SizedBox(width: 10.w),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.to(ChatScreen());
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 28.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(7.r),
                                    ),
                                    child: Text(
                                      'Message',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),*/
                            SizedBox(width: 30.w),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: InkWell(
                            onTap: () async {
                              bool? x = await Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return EditProfilePage(profile: state.profile!);
                              }));
                              if (x == true) {
                                _fetchProfileInfo();
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 35.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.r),
                                      bottomLeft: Radius.circular(5.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                        'assets/icons/editsanad.svg'),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Expanded(
                                  child: Container(
                                    height: 30.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F1F1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Container(
                                  height: 30.h,
                                  width: 35.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F1F1),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5.r),
                                      bottomRight: Radius.circular(5.r),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                        'assets/icons/settingssanad.svg'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  SizedBox(height: 10.h),
                  (state.profile?.bio.isEmpty ?? true)
                      ? SizedBox.shrink()
                      : Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Text(
                                state.profile?.bio ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  height: 1.5,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        ),
                  ProfilePostsWidget(
                    profile: state.profile!,
                    isPost: _selectedTab == 0,
                    scrollController: _scrollController,
                  ),
                ],
              ),
            );
    });
  }
}
