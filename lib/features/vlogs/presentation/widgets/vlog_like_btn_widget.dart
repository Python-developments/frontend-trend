import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/vlog_model.dart';
import 'single_vlog_widget.dart';

import '../../../../core/resources/assets_manager.dart';
import '../../../../core/resources/color_manager.dart';
import '../bloc/vlogs_bloc/vlogs_bloc.dart';

class VlogLikeBtnWidget extends StatefulWidget {
  final VlogModel vlog;
  const VlogLikeBtnWidget({
    Key? key,
    required this.vlog,
  }) : super(key: key);

  @override
  State<VlogLikeBtnWidget> createState() => _VlogLikeBtnWidgetState();
}

class _VlogLikeBtnWidgetState extends State<VlogLikeBtnWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.sp),
      child: GestureDetector(
          onTapDown: (_) {
            setState(() {
              _scale = 1.2;
            });
          },
          onTapUp: (_) async {
            if (context.read<VlogsBloc>().state is! VlogsLoadingState) {
              context.read<VlogsBloc>().add(ToggleLikeEvent(vlog: widget.vlog));
            }

            await Future.delayed(const Duration(milliseconds: 200));
            setState(() {
              _scale = 1.0;
            });
          },
          onTapCancel: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            setState(() {
              _scale = 1.0;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 100),
                scale: _scale,
                child: SvgPicture.asset(
                  "assets/icons/single_post/vlog_like.svg",
                  width: 28.sp,
                  height: 25.sp,
                  color: widget.vlog.likedByUser ? kRedColor : Colors.white,
                ),
              ),
              SizedBox(height: 4.sp),
              Text(
                widget.vlog.likeCount.toString(),
                style: SingleVlogWidgetState.textStyle1,
              ),
            ],
          )),
    );
  }
}
