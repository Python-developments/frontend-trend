// ignore_for_file: deprecated_member_use, unused_local_variable
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/core/resources/color_manager.dart';

import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/shared_pref.dart';
import '../../../../injection_container.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int index = 0;
  changeIndex(int index) {
    this.index = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final isVlog = location.contains("vlog") && !location.contains("profile");
    final sharedPref = sl<SharedPref>();
    final currentUserId = sharedPref.account?.id ?? 0;
    return WillPopScope(
      onWillPop: () async {
        if (location.startsWith(Routes.posts)) return true;

        context.go(Routes.posts);
        return false;
      },
      child: Scaffold(
        extendBody: false,
        bottomNavigationBar: location == Routes.camera
            ? const SizedBox()
            : Container(
                color: Colors.grey[200],
                padding: EdgeInsets.only(top: 1),
                child: Container(
                  // height: 80,
                  // padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isVlog ? Colors.black : Colors.white,
                    // border: Border(
                    //     top: BorderSide(
                    //         color: Theme.of(context).highlightColor, width: .5.sp)),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(14.sp, 10.sp, 14.sp, 25.sp),
                    child: GNav(
                      backgroundColor:
                          isVlog ? Colors.black : Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 15.sp),
                      tabBorderRadius: 20.sp,
                      activeColor:
                          Theme.of(context).textTheme.displayLarge?.color,
                      color: Theme.of(context).hintColor,
                      selectedIndex: _mapLocationToIndex(location),
                      onTabChange: _onTabChanged,
                      iconSize: 30.sp,
                      tabs: [
                        _buildTab(
                            height: 23.sp,
                            context: context,
                            title: "".hardcoded,
                            assetUrl:
                                'assets/icons/bottom_nav_bar/home_icon.svg',
                            route: Routes.posts,
                            color:
                                index == 0 ? Colors.black : Color(0xffb8b8b8)),
                        _buildTab(
                            height: 23.sp,
                            context: context,
                            title: "".hardcoded,
                            assetUrl:
                                'assets/icons/bottom_nav_bar/search_sanad.svg',
                            route: Routes.explore,
                            color:
                                index == 1 ? Colors.black : Color(0xffb8b8b8)),

                        _buildTab(
                            context: context,
                            height: 23.sp,
                            title: "".hardcoded,
                            assetUrl: 'assets/icons/plus-circle.svg',
                            route: Routes.notificationPage,
                            color:
                                index == 2 ? Colors.black : Color(0xffb8b8b8)),

                        // Image.asset(),
                        // _buildTab(
                        //     context: context,
                        //     title: "Camera".hardcoded,
                        //     assetUrl: 'assets/icons/bottom_nav_bar/scan.svg',
                        //     route: Routes.camera),

                        _buildTab(
                            context: context,
                            height: 23.sp,
                            title: "".hardcoded,
                            assetUrl: 'assets/icons/bottom_nav_bar/bell.svg',
                            route: Routes.notificationPage,
                            color:
                                index == 3 ? Colors.black : Color(0xffb8b8b8)),

                        _buildTab(
                            context: context,
                            height: 23.sp,
                            title: "".hardcoded,
                            assetUrl: "",
                            route: Routes.profile,
                            child: CustomCachedImageWidget(
                                size: 25.sp,
                                errorWidget: SvgPicture.asset(
                                  'assets/icons/person.svg',
                                  color: index == 4
                                      ? Colors.black
                                      : Color(0xffb8b8b8),
                                ),
                                imageUrl: context
                                        .watch<CurrentUserCubit>()
                                        .state
                                        .user
                                        ?.avatar ??
                                    ""),
                            color:
                                index == 4 ? Colors.black : Color(0xffb8b8b8)),

                        // _profileTab(context, location, currentUserId),
                      ],
                    ),
                  ),
                ),
              ),
        body: widget.child,
      ),
    );
  }

  GButton _profileTab(
      BuildContext context, String location, int currentUserId) {
    return _buildTab(
        context: context,
        title: "",
        assetUrl: "",
        child: Column(
          children: [
            SizedBox(height: 3.sp),
            CustomCachedImageWidget(
                size: 25.sp,
                errorWidget: SvgPicture.asset(
                  'assets/icons/person.svg',
                  color: index == 4 ? Colors.black : Color(0xffb8b8b8),
                ),
                imageUrl:
                    context.watch<CurrentUserCubit>().state.user?.avatar ?? ""),
          ],
        ),
        route: Routes.profile);
  }

  GButton _buildTab(
      {required BuildContext context,
      required String title,
      required String assetUrl,
      required String route,
      Color? color,
      Widget? child,
      double? height,
      double? width}) {
    return GButton(
      icon: Icons.home_outlined,
      gap: 10.sp,
      leading: IconTheme(
          data: IconThemeData(
            color: _getTabColor(route),
          ),
          child: child ??
              Column(
                children: [
                  SizedBox(
                    height: height ?? 25.sp,
                    child: SvgPicture.asset(
                      assetUrl,
                      color: color,
                      height: height ?? 25.sp,
                      width: width,
                    ),
                  ),
                ],
              )),
    );
  }

  Color _getTabColor(String route) {
    final location = GoRouterState.of(context).uri.toString();

    final isVlog =
        location.startsWith("/vlog") && !location.contains("profile");
    if (isVlog) {
      return route.startsWith("/vlog") ? Colors.white : kGreyColor;
    }
    return location.startsWith(route)
        ? Theme.of(context).textTheme.displayLarge!.color!
        : Theme.of(context).textTheme.headlineMedium!.color!;
  }

  int _mapLocationToIndex(String location) {
    if (location.startsWith(Routes.posts)) {
      return 0;
    }
    if (location.startsWith(Routes.explore)) {
      return 1;
    }

    if (location.startsWith(Routes.newPost)) {
      return 2;
    }

    if (location.startsWith(Routes.notificationPage)) {
      return 3;
    }

    if (location.startsWith("profile")) {
      return 4;
    }

    return 0;
  }

  void _onTabChanged(int value) {
    setState(() {
      index = value;
    });
    switch (value) {
      case 0:
        GoRouter.of(context).go(Routes.posts);
      case 1:
        GoRouter.of(context).go(Routes.explore);
      case 2:
        GoRouter.of(context)
            .go(Routes.newPost, extra: {"function": changeIndex});
        break;
      // GoRouter.of(context).go(Routes.camera);
      case 3:
        GoRouter.of(context).go(Routes.notificationPage);
      case 4:
        GoRouter.of(context).go(Routes.profile);
    }
  }
}
