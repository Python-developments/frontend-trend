// ignore_for_file: must_be_immutable
class VlogModel {
  final int id;
  final int customUserId;
  final int authorProfileId;
  final String username;
  final String authorAvatar;
  final String videoUrl;
  final String videoThumb;
  final String content;
  final DateTime createdAt;
  final Duration duration;
  final DateTime updatedAt;
  int likeCount;
  final int commentCount;
  bool likedByUser;

  VlogModel({
    required this.id,
    required this.authorProfileId,
    required this.customUserId,
    required this.duration,
    required this.username,
    required this.authorAvatar,
    required this.videoUrl,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.videoThumb,
    required this.likedByUser,
  });

  factory VlogModel.fromJson(Map<String, dynamic> json) {
    return VlogModel(
      id: json['id'] ?? 0,
      authorProfileId: json['profile_id'] ?? 0,
      customUserId: json['custom_user_id'] ?? 0,
      duration: parseDuration(json['duration']),
      username: json['username'] ?? '',
      authorAvatar: json['avatar'] ?? '',
      videoThumb: json['video_thumb'] ?? '',
      videoUrl: json['video'] ?? '',
      content: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      updatedAt: DateTime.parse(json['updated_at'] ?? ''),
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      likedByUser: json['liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_user_id': customUserId,
      'profile_id': authorProfileId,
      'username': username,
      'auther_avatar': authorAvatar,
      'duration': duration,
      'videoThumb': videoThumb,
      'videoUrl': videoUrl,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'like_count': likeCount,
      'comment_count': commentCount,
      'liked': likedByUser,
    };
  }

  VlogModel copyWith({
    int? id,
    int? customUserId,
    int? authorProfileId,
    String? username,
    String? authorAvatar,
    String? videoUrl,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likeCount,
    int? commentCount,
    bool? likedByUser,
  }) {
    return VlogModel(
      id: id ?? this.id,
      authorProfileId: authorProfileId ?? this.authorProfileId,
      customUserId: customUserId ?? this.customUserId,
      videoThumb: videoThumb,
      duration: duration,
      username: username ?? this.username,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      videoUrl: videoUrl ?? this.videoUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      likedByUser: likedByUser ?? this.likedByUser,
    );
  }

  @override
  bool operator ==(covariant VlogModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customUserId == customUserId &&
        other.authorProfileId == authorProfileId &&
        other.username == username &&
        other.authorAvatar == authorAvatar &&
        other.videoThumb == videoThumb &&
        other.videoUrl == videoUrl &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.likeCount == likeCount &&
        other.commentCount == commentCount &&
        other.likedByUser == likedByUser;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customUserId.hashCode ^
        authorProfileId.hashCode ^
        username.hashCode ^
        authorAvatar.hashCode ^
        videoThumb.hashCode ^
        videoUrl.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        likeCount.hashCode ^
        commentCount.hashCode ^
        likedByUser.hashCode;
  }
}

Duration parseDuration(String? duration) {
  if (duration == null) {
    return const Duration(seconds: 0);
  }
  final parts = duration.split(':');
  final hours = int.parse(parts[0]);
  final minutes = int.parse(parts[1]);
  final secondsParts = parts[2].split('.');
  final seconds = int.parse(secondsParts[0]);
  final microseconds = int.parse(secondsParts[1].padRight(6, '0'));

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    microseconds: microseconds,
  );
}
