import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/models/vlog_model.dart';

Future<void> shareVlog(VlogModel vlog) async {
  // Extract the file name without query parameters
  final String videoFileName = p.basename(vlog.videoUrl.split('?').first);
  final Directory tempDir = await getTemporaryDirectory();
  final String videoPath = p.join(tempDir.path, videoFileName);

  try {
    // Download the video
    await Dio().download(vlog.videoUrl, videoPath);
  } catch (e) {
    debugPrint('Error downloading video: $e');
    return;
  }

  try {
    // Share the video
    await Share.shareXFiles([XFile(videoPath)],
        text: '${vlog.username}: ${vlog.content}');
  } catch (e) {
    debugPrint('Error sharing vlog: $e');
  }
}
