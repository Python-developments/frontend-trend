import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/utils/share_post.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/post_model.dart';
import 'comments/post_comments_modal_widget.dart';

class PostButtons extends StatefulWidget {
  final PostModel post;
  final bool isProfilepost;
  final List<PostModel> profilePosts;
  const PostButtons(
      {Key? key,
      required this.post,
      required this.isProfilepost,
      required this.profilePosts})
      : super(key: key);

  @override
  State<PostButtons> createState() => _PostButtonsState();
}

class _PostButtonsState extends State<PostButtons> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final postBtnsStyle = TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
        color: Theme.of(context).textTheme.bodyMedium!.color!);
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30.sp),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      if (widget.isProfilepost) {
                        context.read<PostsBloc>().add(ToggleLocalReactionEvent(
                            context: context,
                            post: widget.post,
                            posts: widget.profilePosts,
                            reactionType: widget.post.userReaction == null
                                ? "like"
                                : "remove",
                            user: context.read<CurrentUserCubit>().state.user));
                      } else {
                        context.read<PostsBloc>().add(ToggleReactionEvent(
                            post: widget.post,
                            reactionType: widget.post.userReaction == null
                                ? "like"
                                : "remove",
                            user: context.read<CurrentUserCubit>().state.user));
                      }
                    },
                    child: Row(
                      children: [
                        widget.post.userReaction != null
                            ? SvgPicture.asset(
                                'assets/icons/like_fill.svg',
                                height: 15.sp,
                              )
                            : SvgPicture.asset(
                                'assets/icons/like.svg',
                                height: 15.sp,
                              ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          widget.post.totalReactionsCount == 0
                              ? 'Like'
                              : '${widget.post.totalReactionsCount} ' +
                                  (widget.post.totalReactionsCount == 1
                                      ? "Like"
                                      : "Likes"), // Display the number of comments
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp, // Reduced font size
                          ),
                        ),
                      ],
                    )),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                    onTap: () {
                      showCommentsModal(context, widget.post);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/chat_2.svg',
                            height: 17.sp,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            widget.post.commentCount == 0
                                ? 'Comment'
                                : '${widget.post.commentCount} Comments'
                                    .toString(), // Display the number of likes
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp, // Reduced font size
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    sharePost(widget.post);
                  },
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/share.svg',
                          height: 13.sp,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          'Share'.toString(), // Display the number of likes
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp, // Reduced font size
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // Pushes the share icon to the right
            ],
          ),
        ),
      ],
    );
  }
}
