import 'package:flutter/material.dart';

class VideoThumbnailLoader extends StatelessWidget {
  const VideoThumbnailLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
