import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/locale/app_localizations.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message ?? "No data found".hardcoded,
          style:
              Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13.sp),
        ),
        // SizedBox(height: 40,),
      ],
    );
  }
}
