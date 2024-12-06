import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoControls extends StatelessWidget {
  final CachedVideoPlayerPlusController controller;

  const VideoControls({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(16.sp),
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Colors.black38),
          child: GestureDetector(
            child: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 25.sp,
            ),
            onTap: () {
              controller.value.isPlaying
                  ? controller.pause()
                  : controller.play();
            },
          ),
        ),
        // IconButton(
        //   icon: Icon(
        //     controller.value.volume == 0 ? Icons.volume_off : Icons.volume_up,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     controller.setVolume(controller.value.volume == 0 ? 1.0 : 0.0);
        //   },
        // ),
      ],
    );
  }
}
