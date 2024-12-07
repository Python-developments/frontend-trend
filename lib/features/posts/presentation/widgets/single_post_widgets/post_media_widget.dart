import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_trend/core/widgets/logo_loader.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/resources/color_manager.dart';
import '../../../data/models/post_model.dart';
import '../../bloc/posts_bloc/posts_bloc.dart';
import 'single_post_images_slider_widget.dart';

class PostMediaWidget extends StatefulWidget {
  final PostModel post;
  final Function function;
  const PostMediaWidget({Key? key, required this.post, required this.function})
      : super(key: key);

  @override
  State<PostMediaWidget> createState() => _PostMediaWidgetState();
}

class _PostMediaWidgetState extends State<PostMediaWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isAnimating = false;
  double _heartSize = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween(begin: 1.0, end: 1.5).animate(_controller)
      ..addListener(() {
        setState(() {
          _heartSize = 30.sp * _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _isAnimating = false;
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateHeart() async {
    if (!_isAnimating) {
      _isAnimating = true;
      _controller.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      _controller.reset();
    }
  }

  Future<void> _likeOrUnLikePost(BuildContext context) async {
    context.read<PostsBloc>().add(ToggleReactionEvent(
        post: widget.post,
        reactionType: 'love',
        user: context.read<CurrentUserCubit>().state.user));

    _animateHeart();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _heartSize = 0.0;
    });
  }

  double calculateHeighAndWidth() {
    double? height = widget.post.height;
    double? width = widget.post.width;
    if (height != null && width != null) {
      double screenWidth = Get.width;
      double newHeight = height * screenWidth / width;
      return newHeight;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = calculateHeighAndWidth();
    return GestureDetector(
      onDoubleTap: () async {
        await _likeOrUnLikePost(context);
      },
      child: Stack(
        children: [
          // Image.network(widget.post.image),
          PinchZoomReleaseUnzoomWidget(
            fingersRequiredToPinch: 2,
            twoFingersOn: () {
              widget.function(true);
            },
            twoFingersOff: () {
              widget.function(false);
            },
            child: Container(
              height: height > Get.height * 0.7 ? Get.height * 0.7 : null,
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: widget.post.image,
                placeholder: (context, x) {
                  return Shimmer.fromColors(
                    baseColor: Theme.of(context).highlightColor,
                    highlightColor: Theme.of(context).dividerColor,
                    child: Container(
                      width: double.infinity,
                      height:
                          height > Get.height * 0.7 ? Get.height * 0.7 : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey[200],
                    padding: EdgeInsets.all(50.sp),
                    child: Image.asset(
                      'assets/icons/logo_trend.png',
                    ),
                  );
                },
              ),
            ),
          )
          // Container(
          //   height: 300,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: CachedNetworkImageProvider(widget.post.image),
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
          ,
          _heartSize > 0
              ? Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Icon(
                    Icons.favorite,
                    color: kRedColor,
                    size: _heartSize,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
