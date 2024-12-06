class CommentModel {
  final int id;
  final int customUserId;
  final int commenterProfileId;
  final String commenterName;
  final String commenterAvatar;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommentModel({
    required this.id,
    required this.commenterProfileId,
    required this.customUserId,
    required this.commenterName,
    required this.commenterAvatar,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commenterProfileId: json['profile_id'] ?? 0,
      id: json['id'] ?? 0,
      customUserId: json['custom_user_id'] ?? 0,
      commenterName: json['username'] ?? '',
      commenterAvatar: json['avatar'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_user_id': customUserId,
      'profile_id': commenterProfileId,
      'commenter': commenterName,
      'avatar': commenterAvatar,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
