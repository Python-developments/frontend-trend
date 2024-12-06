import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../data/models/profile_model.dart';

class ProfileImageAndCoverWidget extends StatelessWidget {
  final ProfileModel profile;
  const ProfileImageAndCoverWidget({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: 120.sp,
        ),
        Positioned(
            child: InkWell(
          onTap: () {
            log(profile.avatar);
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 60.sp,
            child: CustomCachedImageWidget(
                addBorder: true,
                size: 100.sp,
                radius: 100.sp,
                imageUrl: profile.avatar),
          ),
        )),
        // Positioned(
        //     top: 40.sp,
        //     right: 10,
        //     child: SvgPicture.asset('assets/icons/profile/settings.svg'))
      ],
    );
  }
}
