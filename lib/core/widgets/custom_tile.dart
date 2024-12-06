import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTileWidget extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final Color? titleColor;
  final bool showTrailing;
  final String? iconIAssetUrl;
  final Color? assetColor;
  final double? assetSize;
  final Widget? trailing;
  const CustomTileWidget({
    Key? key,
    this.onTap,
    this.trailing,
    required this.title,
    this.titleColor,
    this.assetColor,
    this.assetSize,
    this.showTrailing = true,
    this.iconIAssetUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: false,
      dense: true,
      horizontalTitleGap: 12.sp,
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14.sp, color: titleColor, fontWeight: FontWeight.w500),
      ),
      leading: iconIAssetUrl != null
          ? SvgPicture.asset(
              iconIAssetUrl!,
              height: assetSize ?? 25.sp,
              width: assetSize ?? 25.sp,
              colorFilter: ColorFilter.mode(
                  assetColor ??
                      Theme.of(context).textTheme.displayLarge!.color!,
                  BlendMode.srcIn),
            )
          : null,
      trailing: showTrailing
          ? trailing ??
              Icon(
                Icons.arrow_forward_ios,
                size: 18.sp,
              )
          : null,
    );
  }
}
