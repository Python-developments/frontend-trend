import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/resources/color_manager.dart';
import '../../data/models/profile_model.dart';

class ProfileInformationsWidget extends StatelessWidget {
  final ProfileModel profile;
  const ProfileInformationsWidget({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            "Shady Samara",
            style:
                GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 20.sp),
          ),
        ),
        Center(
          child: Text(
            "@" + profile.username,
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: Colors.grey),
          ),
        ),
        profile.bio == ''
            ? SizedBox()
            : Center(
                child: Text(
                  "@${profile.bio}",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: Color(0xff979797)),
                ),
              ),
        if (profile.bio.trim().isNotEmpty) Gap(10.sp),
        if (profile.bio.trim().isNotEmpty)
          SizedBox(
            width: 303.sp,
            child: Center(
              child: Text(
                "@ali_123",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: kGreyColor2,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        Gap(12.sp),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStatis(context, "Posts".hardcoded,
                  profile.postsCount.toString(), () {}),
              Container(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
                height: 25,
              ),
              _buildStatis(context, "Followers".hardcoded,
                  profile.followersCount.toString(), () {
                if (profile.followersCount != 0) {
                  context.push(Routes.profileFollowers(profile.id));
                }
              }),
              Container(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
                height: 25,
              ),
              _buildStatis(context, "Following".hardcoded,
                  profile.followingCount.toString(), () {
                if (profile.followingCount != 0) {
                  context.push(Routes.profileFollowing(profile.id));
                }
              }),
              Container(
                color: Colors.grey.withOpacity(0.3),
                width: 1,
                height: 25,
              ),
              _buildStatis(context, "Likes".hardcoded, profile.toString(), () {
                if (profile.followingCount != 0) {
                  context.push(Routes.profileFollowing(profile.id));
                }
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatis(
      BuildContext context, String title, String count, Function()? onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700, fontSize: 16.sp),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: Color(0xff878787)),
            ),
          ],
        ),
      ),
    );
  }
}
