import 'dart:developer';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../custom_cached_image.dart';
import 'video_controls.dart';
import 'video_progress_indicator.dart';
import 'video_thumbnail_loader.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final Duration duration;
  final String videoThumb;

  const VideoPlayerWidget({
    Key? key,
    required this.url,
    required this.videoThumb,
    required this.duration,
  }) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  CachedVideoPlayerPlusController? _controller;
  bool _isLoading = true;
  bool _controlsVisible = false;

  @override
  void initState() {
    super.initState();
    _controller =
        CachedVideoPlayerPlusController.networkUrl(Uri.parse(widget.url))
          ..initialize().then((_) async {
            _controller!.value = _controller!.value.copyWith(
              duration: widget.duration,
            );

            setState(() {
              _isLoading = false;
            });
            _controller!.play();
          });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (_controller!.value.isPlaying) {
      _controller!.pause();
    } else {
      _controller!.play();
    }
    _toggleControlsVisibility();
  }

  void _toggleControlsVisibility() {
    setState(() {
      _controlsVisible = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _controlsVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_player_${widget.url}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 0 && mounted) {
          _controller?.pause();
        }
        //  else {
        //   _controller?.play();
        // }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: _isLoading
                  ? InkWell(
                      onTap: () {
                        log(widget.url);
                      },
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomCachedImageWidget(
                              imageUrl: widget.videoThumb,
                              radius: 0,
                              size: MediaQuery.sizeOf(context).width,
                              height: MediaQuery.sizeOf(context).height,
                            ),
                          ),
                          const VideoThumbnailLoader(),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: _togglePlayback,
                      child: CachedVideoPlayerPlus(_controller!),
                    ),
            ),
            if (!_isLoading) ...[
              PositionedDirectional(
                top: 12.sp,
                end: 12.sp,
                child: ValueListenableBuilder(
                  valueListenable: _controller!,
                  builder: (context, CachedVideoPlayerPlusValue value, child) {
                    final duration = widget.duration;
                    final position = value.position;

                    if (duration <= const Duration(seconds: 1)) {
                      return Container(); // Avoid rendering if duration is not valid
                    }

                    final remainingDuration = duration - position;
                    final remainingMinutes = remainingDuration.inMinutes;
                    final remainingSeconds = remainingDuration.inSeconds % 60;
                    return Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.sp, vertical: 5.sp),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(20.sp),
                        ),
                        child: Text(
                          '$remainingMinutes:${remainingSeconds.toString().padLeft(2, '0')}',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (!(_controller!.value.duration <= const Duration(seconds: 1)))
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ValueListenableBuilder(
                    valueListenable: _controller!,
                    builder:
                        (context, CachedVideoPlayerPlusValue value, child) {
                      return VideoProgressIndicatorWidget(
                        controller: _controller!,
                      );
                    },
                  ),
                ),
              if (_controlsVisible)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: VideoControls(controller: _controller!),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomVideoController {
  final CachedVideoPlayerPlusController _controller;
  Duration? _manualDuration;

  CustomVideoController(this._controller);

  void setManualDuration(Duration duration) {
    _manualDuration = duration;
  }

  Duration? get duration => _manualDuration ?? _controller.value.duration;

  void dispose() {
    _controller.dispose();
  }
}
