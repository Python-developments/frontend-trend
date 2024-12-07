import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/post_model.dart';
import 'post_media_widget.dart';
import 'user_image_username_and_menu.dart';
import 'post_buttons.dart';

class SinglePostWidget extends StatefulWidget {
  final PostModel post;
  final Function function;
  final bool isprofilePost;
  final List<PostModel> profilePosts;
  const SinglePostWidget(
      {Key? key,
      required this.post,
      required this.function,
      this.isprofilePost = false,
      this.profilePosts = const []})
      : super(key: key);

  @override
  State<SinglePostWidget> createState() => _SinglePostWidgetState();
}

class _SinglePostWidgetState extends State<SinglePostWidget>
    with SingleTickerProviderStateMixin {
  int currentImageIndex = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserImageAndUsernameAndMenu(post: widget.post),
        PostMediaWidget(
          post: widget.post,
          function: widget.function,
        ),
        SizedBox(
          height: 10.sp,
        ),
        PostButtons(
          profilePosts: widget.profilePosts,
          post: widget.post,
          isProfilepost: widget.isprofilePost,
        ),
        Divider(
          color: Color(0xffededed),
        ),
        SizedBox(
          height: 5.sp,
        ),
      ],
    );
  }
}
