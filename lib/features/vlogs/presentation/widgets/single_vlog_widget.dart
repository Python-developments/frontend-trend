import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../core/resources/assets_manager.dart';
import '../../../../core/widgets/video_player/video_player_widget.dart';
import '../../data/models/vlog_model.dart';
import '../bloc/vlogs_bloc/vlogs_bloc.dart';
import 'vlog_like_btn_widget.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/shared_pref.dart';
import '../../../../core/widgets/custom_cached_image.dart';
import '../../../../injection_container.dart';
import '../bloc/utils/share_vlog.dart';
import 'comments/vlog_comments_modal_widget.dart';
import 'single_vlog_modal.dart';

class SingleVlogWidget extends StatefulWidget {
  final VlogModel vlog;
  // final VlogsBloc vlogsBloc;
  const SingleVlogWidget({
    Key? key,
    required this.vlog,
    // required this.vlogsBloc,
  }) : super(key: key);

  @override
  State<SingleVlogWidget> createState() => SingleVlogWidgetState();
}

class SingleVlogWidgetState extends State<SingleVlogWidget> {
  static TextStyle textStyle1 = TextStyle(
    color: Colors.white,
    fontSize: 12.sp,
  );
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayerWidget(
          url: widget.vlog.videoUrl,
          duration: widget.vlog.duration,
          videoThumb: widget.vlog.videoThumb,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                log(widget.vlog.authorAvatar);
                // context.go(Routes.profileDetails(widget.vlog.authorProfileId));
              },
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                        vertical: 4.sp, horizontal: 15.sp)
                    .copyWith(end: 10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.sp).copyWith(left: 0, right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * .5.w,
                              child: Text(
                                widget.vlog.username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // if (widget.post.description.trim().isEmpty)
                          //    SizedBox(height: 4),
                          // if (widget.post.description.trim().isNotEmpty)
                          SizedBox(height: 8.sp),
                          // if (widget.post.description.trim().isNotEmpty)
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .5.sp,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: ExpandableText(
                                  widget.vlog.content,
                                  style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  expandText: 'more'.hardcoded,
                                  collapseText: 'less'.hardcoded,
                                  expandOnTextTap: true,
                                  collapseOnTextTap: true,
                                  maxLines: 3,
                                  linkColor: Colors.grey,
                                )),
                          ),
                          SizedBox(height: 8.sp),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: 70.sp,
                              ),
                              CustomCachedImageWidget(
                                  size: 58.sp,
                                  addBorder: true,
                                  imageUrl: widget.vlog.authorAvatar),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.all(3.sp),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 20.sp,
                                      width: 20.sp,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.add,
                                        size: 15.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          VlogLikeBtnWidget(vlog: widget.vlog),
                          Padding(
                            padding: EdgeInsets.only(bottom: 25.sp),
                            child: InkWell(
                              onTap: () async {
                                showVlogCommentsModal(context.read<VlogsBloc>(),
                                    context, widget.vlog);
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/single_post/vlog_comment.svg",
                                    width: 25.sp,
                                    height: 24.sp,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                  SizedBox(height: 4.sp),
                                  Text(
                                    widget.vlog.commentCount.toString(),
                                    style: textStyle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 25.sp),
                            child: InkWell(
                              onTap: () async {
                                shareVlog(widget.vlog);
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/single_post/vlog_save.svg",
                                    width: 25.sp,
                                    height: 26.sp,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                  SizedBox(height: 4.sp),
                                  Text(
                                    "Save".hardcoded,
                                    style: textStyle1.copyWith(fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 25.sp),
                            child: InkWell(
                              onTap: () async {
                                shareVlog(widget.vlog);
                              },
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/single_post/vlog_share.svg",
                                    width: 26.sp,
                                    height: 19.sp,
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                  ),
                                  SizedBox(height: 4.sp),
                                  Text(
                                    "Share".hardcoded,
                                    style: textStyle1.copyWith(fontSize: 11.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        PositionedDirectional(
          top: 14.sp,
          start: 10.sp,
          child: Row(
            children: [
              if (sl<SharedPref>().account!.id == widget.vlog.customUserId)
                GestureDetector(
                    onTap: () => showVlogModal(
                        context, context.read<VlogsBloc>(), widget.vlog),
                    child: SizedBox(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
                    )),
              if (sl<SharedPref>().account!.id == widget.vlog.customUserId)
                SizedBox(width: 10.sp),
              GestureDetector(
                  onTap: () {
                    context.push(Routes.camera, extra: {"isVlog": true});
                  },
                  child: SizedBox(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
