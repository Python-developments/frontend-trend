import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/core/resources/assets_manager.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/models/profile_model.dart';
import '../bloc/profile_bloc/profile_bloc.dart';
import 'single_profile_button.dart';

import '../../../../config/routes/app_routes.dart';

class ProfileButtonsWidget extends StatelessWidget {
  final bool isCurrentUser;
  final ProfileModel profile;
  const ProfileButtonsWidget({
    Key? key,
    required this.isCurrentUser,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? InkWell(
            onTap: () {
              context.go(Routes.editProfile, extra: {"profile": profile});
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              width: 330.w,
              height: 48.h,
              decoration: BoxDecoration(
                  color: Color(0xffefefef),
                  borderRadius: BorderRadius.circular(10.r)),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SvgPicture.asset(
                      "assets/icons/single_post/pen.svg",
                      height: 21.sp,
                      width: 21.sp,
                      fit: BoxFit.scaleDown,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 5,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  Text(
                    "Edit Profile".hardcoded,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 5,
                    color: Colors.white,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SvgPicture.asset(
                      "assets/icons/single_post/settings.svg",
                      height: 21.sp,
                      width: 21.sp,
                      fit: BoxFit.scaleDown,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          )
        : BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleProfileButtonWidget(
                        title: profile.isFollowing
                            ? "Following".hardcoded
                            : "Follow".hardcoded,
                        onPressed: state is ProfileFollowLoadingState
                            ? null
                            : () {
                                context.read<ProfileBloc>().add(ToggleFollowEv(
                                    otherUserId: profile.id,
                                    isFollow: !profile.isFollowing,
                                    context: context));
                              },
                        backgroundColor: profile.isFollowing
                            ? Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .color
                                : Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .color!
                            : Theme.of(context).primaryColor,
                        titleColor:
                            profile.isFollowing ? Colors.black : Colors.white,
                        child: state is ProfileFollowLoadingState
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                    ),
                    Expanded(
                      child: SingleProfileButtonWidget(
                        title: "Messages".hardcoded,
                        onPressed: () {
                          GoRouter.of(context).go(Routes.chatPage);
                        },
                        backgroundColor: Color(0xffefefef),
                        titleColor: Colors.black,
                        child: null,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
