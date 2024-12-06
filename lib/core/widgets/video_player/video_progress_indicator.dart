import 'package:flutter/material.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';

class VideoProgressIndicatorWidget extends StatelessWidget {
  final CachedVideoPlayerPlusController controller;

  const VideoProgressIndicatorWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: VideoProgressIndicator(
              controller,
              allowScrubbing: false,
              colors: const VideoProgressColors(
                playedColor: Colors.red,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black,
              ),
            ),
          ),
          // Positioned.fill(
          //   child: ValueListenableBuilder(
          //     valueListenable: controller,
          //     builder: (context, CachedVideoPlayerPlusValue value, child) {
          //       final position = value.position;
          //       final duration = value.duration;

          //       if (duration.inMilliseconds == 0) {
          //         return Container();
          //       }

          //       final progress =
          //           position.inMilliseconds / duration.inMilliseconds;
          //       final progressWidth =
          //           MediaQuery.of(context).size.width * progress;

          //       return Stack(
          //         children: [
          //           Positioned(
          //             left: progressWidth - 10,
          //             top: 1,
          //             child: GestureDetector(
          //               onHorizontalDragUpdate: (details) {
          //                 final newPosition = (details.localPosition.dx /
          //                         MediaQuery.of(context).size.width) *
          //                     duration.inMilliseconds;
          //                 controller.seekTo(
          //                     Duration(milliseconds: newPosition.toInt()));
          //               },
          //               child: Container(
          //                 width: 10,
          //                 height: 10,
          //                 decoration: const BoxDecoration(
          //                   color: Colors.red,
          //                   shape: BoxShape.circle,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
