class UserModel {
  final int id;
  final int profileId;
  final String username;
  final String avatar;
  final String accessToken;
  final String refreshToken;

  UserModel({
    required this.id,
    required this.profileId,
    required this.username,
    required this.avatar,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    String avatari = jsonData['avatar'] ?? '';
    avatari = avatari;
    return UserModel(
      id: jsonData['id'],
      profileId: jsonData['profile_id'],
      username: jsonData['user'],
      avatar: avatari,
      refreshToken: jsonData['refresh'],
      accessToken: jsonData['access'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'profile_id': profileId,
      'user': username,
      'avatar': avatar,
      'access': accessToken,
      'refresh': refreshToken,
    };
  }

  UserModel copyWith({
    int? id,
    int? profileId,
    String? username,
    String? avatar,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
