// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../data/models/post_model.dart';

import 'package:path/path.dart' as p;

Future<void> sharePost(PostModel post) async {
  final String imageFileName = p.basename(post.image.split('?').first);
  final Directory tempDir = await getTemporaryDirectory();
  final String imagePath = p.join(tempDir.path, imageFileName);

  try {
    await Dio().download(post.image, imagePath);
  } catch (e) {
    debugPrint('Error downloading image: $e');
    return;
  }

  try {
    // Share the image
    await Share.shareXFiles([XFile(imagePath)],
        text: '${post.username}: ${post.content}');
  } catch (e) {
    debugPrint('Error sharing post: $e');
  }
}
