import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../resources/assets_manager.dart';

class LogoLoader extends StatelessWidget {
  const LogoLoader({super.key, this.size});
  final double? size;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Pulse(
      key: UniqueKey(),
      infinite: true,
      child: SizedBox(
        height: size ?? 45,
        width: size ?? 45,
        child: Image.asset(
            isDark ? ImgAssets.logoIconWhite : ImgAssets.logoIconDark),
      ),
    );
  }
}
