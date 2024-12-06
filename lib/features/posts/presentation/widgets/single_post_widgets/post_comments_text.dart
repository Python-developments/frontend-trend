import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../config/locale/app_localizations.dart';
import '../../../data/models/post_model.dart';

import 'comments/post_comments_modal_widget.dart';

class PostCommentsText extends StatefulWidget {
  final PostModel post;
  const PostCommentsText({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostCommentsText> createState() => _PostCommentsTextState();
}

class _PostCommentsTextState extends State<PostCommentsText> {
  @override
  Widget build(BuildContext context) {
    return widget.post.commentCount == 0
        ? Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 12.sp),
            child: Text(
              "No comments yet.".hardcoded,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall!.color!,
                fontSize: 12.sp,
              ),
            ),
          )
        : GestureDetector(
            onTap: () async {
              showCommentsModal(context, widget.post);
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 12.sp),
              child: Text(
                'View all ${widget.post.commentCount} comments'.hardcoded,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall!.color!,
                  fontSize: 12.sp,
                ),
              ),
            ),
          );
  }
}
