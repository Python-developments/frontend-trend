import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:readmore/readmore.dart';
import '../../../../../config/routes/app_routes.dart';
import '../../../data/models/post_model.dart';
import 'single_post_modal.dart';

class UserImageAndUsernameAndMenu extends StatefulWidget {
  final PostModel post;
  const UserImageAndUsernameAndMenu({Key? key, required this.post})
      : super(key: key);

  @override
  State<UserImageAndUsernameAndMenu> createState() =>
      _UserImageAndUsernameAndMenuState();
}

class _UserImageAndUsernameAndMenuState
    extends State<UserImageAndUsernameAndMenu> {
  String getTimeAgoShort(DateTime createdAt) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d'; // e.g. "1 d"
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h'; // e.g. "5 h"
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m'; // e.g. "10 m"
    } else {
      return '${difference.inSeconds}s'; // e.g. "30 s"
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the timestamp into a human-readable string like "1 min ago", "5 hrs ago"
    String timeAgo = getTimeAgoShort(widget.post.createdAt);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  context
                      .push(Routes.profileDetails(widget.post.authorProfileId));
                },
                child: Row(
                  children: [
                    CustomCachedImageWidget(
                      size: 33,
                      imageUrl: widget.post.authorAvatar,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.username.toLowerCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Wrap '10m' and 'Icon' in a Row
              Row(
                children: [
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 5.w), // Adjust spacing between '10m' and Icon
                  InkWell(
                    onTap: () {
                      showPostModal(context, widget.post);
                    },
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.post.content.isEmpty
              ? SizedBox(
                  height: 3.sp,
                )
              : Column(
                  children: [
                    SizedBox(height: 5.h),
                    ReadMoreText(
                      widget.post.content.split("&&&&****&&&&")[0],
                      style: TextStyle(fontWeight: FontWeight.w500),
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      lessStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      moreStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}