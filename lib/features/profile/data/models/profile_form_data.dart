import 'dart:io';

class ProfileFormData {
  final int profileId;
  final File? avatar;
  final File? backgroundImage;
  final String bio;
  final String fName;
  final String lName;
  final String location;
  final String phone;

  ProfileFormData({
    required this.profileId,
    required this.avatar,
    required this.backgroundImage,
    required this.bio,
    required this.fName,
    required this.lName,
    required this.location,
    required this.phone,
  });
}
