import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_cached_image.dart';

class CustomSquarePostMediaWidget extends StatelessWidget {
  final String imageUrl;
  const CustomSquarePostMediaWidget({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: Key(imageUrl),
      fit: StackFit.expand,
      children: [
        CustomCachedImageWidget(
          key: Key(imageUrl),
          size: 100.sp,
          radius: 0,
          addBorder: false,
          imageUrl: imageUrl,
        ),
        // Positioned(
        // top: 8,
        // right: 8,
        // child: SvgPicture.asset(
        //   'assets/icons/profile/multi.svg',
        //   width: 17,
        //   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        // ))
        // Positioned(
        //     right: 8,
        //     top: 8,
        //     child: SvgPicture.asset(
        //       'assets/icons/profile/video_play.svg',
        //       width: 17,
        //       colorFilter:
        //           const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        //     ))
      ],
    );
  }
}
