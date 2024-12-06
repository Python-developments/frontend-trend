import 'dart:io';

class AddPostParams {
  final File imageFile;
  final String description;

  AddPostParams({
    required this.imageFile,
    required this.description,
  });
}
