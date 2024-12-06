import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OutlineAppButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  const OutlineAppButton({
    Key? key,
    required this.onTap,
    required this.text,
    this.textStyle,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.sizeOf(context).width,
      height: height ?? 42.sp,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).primaryColor, width: 1.sp),
              borderRadius: BorderRadius.circular(8.sp)),
          child: Center(
            child: Text(
              text,
              style: textStyle ??
                  TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
