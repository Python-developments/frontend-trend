import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedImageWidget extends StatelessWidget {
  final double size;
  final double? height;
  final String? fileUrl;
  final String imageUrl;
  final double? radius;
  final bool addBorder;
  final Color? borderColor;
  final double? borderWidth;
  final Function()? onTap;
  final Widget? errorWidget;
  const CustomCachedImageWidget(
      {super.key,
      required this.size,
      required this.imageUrl,
      this.radius,
      this.fileUrl,
      this.addBorder = false,
      this.borderColor,
      this.borderWidth,
      this.height,
      this.errorWidget,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: !addBorder
            ? null
            : BoxDecoration(
                border: Border.all(
                    color: borderColor ?? Theme.of(context).primaryColor,
                    width: borderWidth ?? 1.5.sp),
                borderRadius:
                    BorderRadius.circular((radius ?? 300.sp) + 1.5.sp)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius ?? 300.sp),
          child: Container(
            color: Colors.white,
            // padding: EdgeInsets.all(1),
            width: size,
            height: height ?? size,
            child: Padding(
              padding: EdgeInsets.all(addBorder ? 1.sp : 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius ?? 300.sp),
                child: fileUrl != null
                    ? Image.file(
                        File(fileUrl!),
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) {
                          return errorWidget ??
                              Container(
                                // padding: EdgeInsets.all(5.sp),
                                child: SvgPicture.asset(
                                  'assets/icons/default_avatar.svg',
                                ),
                              );
                        },
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Theme.of(context).highlightColor,
                          highlightColor: Theme.of(context).dividerColor,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
