import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/locale/app_localizations.dart';

import '../resources/strings_manager.dart';

class DialogUtils {
  final BuildContext context;

  DialogUtils(this.context);

  Future<dynamic> showConfirmDialog({
    String? titleText,
    String? contentText,
    String? submitButtonText,
    Color? submitButtonColor,
    VoidCallback? onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: titleText != null
              ? Text(
                  context.tr(titleText),
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.displayLarge!.color),
                )
              : null,
          content: contentText != null ? Text(context.tr(contentText)) : null,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).disabledColor,
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Text(
                context.tr(AppStrings.cancel),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: submitButtonColor),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop(true);
                if (onSubmit != null) {
                  onSubmit();
                }
              },
              child: Text(
                submitButtonText ?? context.tr(AppStrings.submit),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showCustomDialog({
    String? titleText,
    required Function(BuildContext context) childBuilder,
    bool useWrap = true,
    bool barrierDismissible = true,
    double? width,
    double? height,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsets? insetPadding,
    AlignmentGeometry? alignment,
    Axis animationAxis = Axis.vertical,
    bool useRootNavigator = true,
    ShapeBorder? shape,
    Duration? transitionDuration,
  }) {
    return showGeneralDialog(
      useRootNavigator: useRootNavigator,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'dialog',
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox();
      },
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final begin = animationAxis == Axis.vertical
            ? const Offset(0, 1)
            : const Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: tween.animate(animation),
          child: AlertDialog(
            contentPadding: contentPadding,
            shape: shape,
            alignment: alignment,
            insetPadding: insetPadding ??
                EdgeInsets.symmetric(horizontal: 40.sp, vertical: 24.sp),
            title: titleText != null ? Text(titleText) : null,
            content: SizedBox(
              width: width ?? 400.sp,
              height: height,
              child: useWrap
                  ? Wrap(
                      children: [
                        childBuilder(context),
                      ],
                    )
                  : childBuilder(context),
            ),
          ),
        );
      },
    );
  }

  void showLoaderDialog() {
    showCustomDialog(
      titleText: "${context.tr(AppStrings.pleaseWait)}...",
      width: 250.sp,
      barrierDismissible: false,
      childBuilder: (context) => Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.sp,
        ),
        child: const LinearProgressIndicator(),
      ),
    );
  }
}
