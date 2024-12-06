// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';

import '../widgets/camera_page/camera_image_video_widget.dart';

class CameraPage extends StatefulWidget {
  final bool isVlog;
  const CameraPage({
    Key? key,
    required this.isVlog,
  }) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return CameraImageVideoWidget(
      allowRecording: widget.isVlog,
      initialCameraType: widget.isVlog ? "Video".hardcoded : "Photo".hardcoded,
      isVlog: widget.isVlog,
      isSingle: true,
      onTaken: (data) {
        if (data['files'] != null && data['files']!.isNotEmpty) {
          if (widget.isVlog) {
            context.go(Routes.takenVlogPreview,
                extra: {"files": (data['files']), "mediaType": data['type']});
          } else {
            context.go(Routes.takenMediaPreview,
                extra: {"files": (data['files']), "mediaType": data['type']});
          }
        }
      },
    );
  }
}
