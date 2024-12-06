import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'app_divider.dart';

class ModalSheetUtils {
  final BuildContext context;

  ModalSheetUtils(this.context);

  void showCustomModalSheet(
      {required Widget child,
      bool removeHeader = false,
      double? height,
      Color? color,
      bool disableScroll = false,
      bool takeJustNeededSize = false,
      required Widget title,
      String? assetImageUrl,
      double? scrollControlDisabledMaxHeightRatio}) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      scrollControlDisabledMaxHeightRatio:
          scrollControlDisabledMaxHeightRatio ?? 2.sp,
      enableDrag: true,
      elevation: 0,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return _CustomModalSheet(
          color: color,
          title: title,
          assetImageUrl: assetImageUrl,
          height: height,
          disableScroll: disableScroll,
          removeHeader: removeHeader,
          takeJustNeededSize: takeJustNeededSize,
          child: child,
        );
      },
    );
  }
}

class _CustomModalSheet extends StatefulWidget {
  final Widget title;
  final String? assetImageUrl;
  final Widget child;
  final double? height;
  final Color? color;
  final bool disableScroll;
  final bool removeHeader;
  final bool takeJustNeededSize;

  const _CustomModalSheet({
    Key? key,
    required this.title,
    required this.disableScroll,
    required this.child,
    this.color,
    required this.removeHeader,
    required this.height,
    required this.takeJustNeededSize,
    this.assetImageUrl,
  }) : super(key: key);

  @override
  __CustomModalSheetState createState() => __CustomModalSheetState();
}

class __CustomModalSheetState extends State<_CustomModalSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: widget.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.sp),
            Container(
              height: 6.sp,
              width: 55.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.sp),
                color: Theme.of(context).textTheme.headlineSmall?.color,
              ),
            ),
            if (!widget.removeHeader) Gap(12.sp),
            if (!widget.removeHeader)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.assetImageUrl != null)
                    SvgPicture.asset(
                      widget.assetImageUrl!,
                      height: 25.sp,
                      width: 25.sp,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.displayLarge!.color!,
                          BlendMode.srcIn),
                    ),
                  if (widget.assetImageUrl != null) SizedBox(width: 4.sp),
                  widget.title
                ],
              ),
            Gap(8.sp),
            if (!widget.removeHeader) const AppDivider(),
            if (widget.takeJustNeededSize)
              widget.disableScroll
                  ? widget.child
                  : Expanded(
                      child: SingleChildScrollView(child: widget.child),
                    )
            else
              widget.disableScroll
                  ? Expanded(child: widget.child)
                  : Expanded(
                      child: SingleChildScrollView(child: widget.child),
                    ),
          ],
        ),
      ),
    );
  }
}
