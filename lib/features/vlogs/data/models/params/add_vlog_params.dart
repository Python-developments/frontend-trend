import 'dart:io';

class AddVlogParams {
  final File videoFile;
  final String description;

  AddVlogParams({
    required this.videoFile,
    required this.description,
  });
}
