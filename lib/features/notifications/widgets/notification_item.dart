import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/widgets/custom_cached_image.dart';
import 'package:frontend_trend/features/notifications/data/models/not_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notificationModel;
  NotificationItem(this.notificationModel);
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
    // TODO: implement build
    return ListTile(
      onTap: () {
        context
            .push(Routes.profileDetails(notificationModel.senderUserId ?? 0));
      },
      leading: CircleAvatar(
        radius: 20, // You can adjust the size
        backgroundColor:
            Colors.transparent, // Optional, remove background color
        child: ClipOval(
          child: CustomCachedImageWidget(
            imageUrl: notificationModel.senderAvatar ?? '',
            size: double.infinity,
            height: double.infinity,
            errorWidget: Container(
                padding: EdgeInsets.all(10.sp),
                child: SvgPicture.asset(
                  'assets/icons/new_user.svg',
                )),
            // Fills the CircleAvatar
          ),
        ),
      ),
      title: RichText(
        text: TextSpan(
          text: notificationModel.senderUsername,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text:
                  ' ${notificationModel.notificationType == "reaction" ? 'has put ${notificationModel.reactionType} on your post' : 'is starting following you'}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      trailing: Text(
          getTimeAgoShort(DateTime.parse(notificationModel.createdAt ?? ''))),
    );
  }
}
