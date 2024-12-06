import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/locale/app_localizations.dart';

class LabeledWidget extends StatelessWidget {
  const LabeledWidget({
    Key? key,
    required this.title,
    this.hint,
    this.borderColor,
    required this.child,
    this.enableStartBorder = false,
  }) : super(key: key);
  final String title;
  final String? hint;
  final Widget child;
  final bool enableStartBorder;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: enableStartBorder
          ? BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: borderColor ??
                      Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 2,
                ),
              ),
            )
          : null,
      padding: enableStartBorder
          ? EdgeInsets.only(
              left: AppLocalizations.of(context)!.isRTL ? 0 : 5.sp,
              right: AppLocalizations.of(context)!.isRTL ? 5.sp : 0)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).textTheme.displayLarge!.color),
          ),
          if (hint != null)
            Padding(
              padding: EdgeInsets.only(top: 5.sp),
              child: Text(
                hint!,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).textTheme.displayLarge!.color),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
