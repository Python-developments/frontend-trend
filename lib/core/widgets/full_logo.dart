import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../resources/assets_manager.dart';

class FullLogo extends StatelessWidget {
  final double? size;
  const FullLogo({
    Key? key,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: size,
      child: SvgPicture.asset(
        isDark ? ImgAssets.logoWhiteSvg : ImgAssets.logoDarkSvg,
        height: size,
      ),
    );
  }
}
