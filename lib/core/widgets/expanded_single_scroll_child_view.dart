import 'package:flutter/material.dart';

class FiniteSizeSingleChildScrollViewNotBotheredByKeyboard
    extends StatefulWidget {
  final Widget child;

  const FiniteSizeSingleChildScrollViewNotBotheredByKeyboard(
      {Key? key, required this.child})
      : super(key: key);

  @override
  State<FiniteSizeSingleChildScrollViewNotBotheredByKeyboard> createState() =>
      _FiniteSizeSingleChildScrollViewNotBotheredByKeyboardState();
}

class _FiniteSizeSingleChildScrollViewNotBotheredByKeyboardState
    extends State<FiniteSizeSingleChildScrollViewNotBotheredByKeyboard> {
  double width = 0, height = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (width != constraints.maxWidth) {
        width = constraints.maxWidth;
        height = constraints.maxHeight;
      }
      return SingleChildScrollView(
        child: SizedBox(
          width: width,
          height: height,
          child: widget.child,
        ),
      );
    });
  }
}
