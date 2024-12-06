import 'package:flutter/material.dart';
import 'loading_widget.dart';

class OverlayLoadingPage extends StatelessWidget {
  const OverlayLoadingPage({
    super.key,
    required this.isLoading,
    required this.child,
  });
  final bool isLoading;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (isLoading)
          const Positioned.fill(
            child: LoaderOverlayWidget(),
          ),
      ],
    );
  }
}

class LoaderOverlayWidget extends StatelessWidget {
  const LoaderOverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(
        0.2,
      ),
      child: const Center(
        child: LoadingWidget(),
      ),
    );
  }
}
