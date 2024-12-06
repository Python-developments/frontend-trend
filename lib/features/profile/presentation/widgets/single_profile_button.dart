import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleProfileButtonWidget extends StatelessWidget {
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final Widget? child;
  final Function()? onPressed;
  final bool setWidth;

  const SingleProfileButtonWidget({
    Key? key,
    required this.title,
    required this.onPressed,
    this.titleColor,
    this.backgroundColor,
    this.child,
    this.setWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            // width: 361.w,
            height: 33.h,
            decoration: BoxDecoration(
                color: backgroundColor ?? Colors.black,
                borderRadius: BorderRadius.circular(10.r)),
            padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 0.sp),
            child: Center(
              child: child ??
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: titleColor ??
                            Theme.of(context).textTheme.displayLarge?.color),
                  ),
            )));
  }
}
