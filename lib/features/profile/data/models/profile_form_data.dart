import 'dart:io';

class ProfileFormData {
  final int profileId;
  final File? avatar;
  final File? backgroundImage;
  final String bio;

  ProfileFormData({
    required this.profileId,
    required this.avatar,
    required this.backgroundImage,
    required this.bio,
  });
}
