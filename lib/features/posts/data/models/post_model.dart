import 'package:equatable/equatable.dart';

class PostModel {
  final int id;
  final int customUserId;
  final int authorProfileId;
  final String username;
  final String authorAvatar;
  final String image;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  int likeCount;
  int commentCount;
  bool likedByUser;
  String? userReaction;
  int totalReactionsCount;
  List<ReactionModel> reactionListCount;
  List<ReactionModel> reactionList;
  List<ReactionModel> topReactions;

  PostModel({
    required this.id,
    required this.authorProfileId,
    required this.customUserId,
    required this.username,
    required this.authorAvatar,
    required this.image,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.likedByUser,
    required this.reactionList,
    required this.totalReactionsCount,
    required this.reactionListCount,
    required this.topReactions,
    required this.userReaction,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    String image = json['image'] ?? '';
    String avatar = json['avatar'] ?? '';
    image = image;
    avatar = avatar;
    return PostModel(
        id: json['id'] ?? 0,
        authorProfileId: json['profile_id'] ?? 0,
        customUserId: json['custom_user_id'] ?? 0,
        username: json['username'] ?? '',
        authorAvatar: avatar,
        image: image,
        content: json['content'] ?? '',
        createdAt: DateTime.parse(json['created_at'] ?? ''),
        updatedAt: DateTime.parse(json['updated_at'] ?? ''),
        likeCount: json['like_counter'] ?? 0,
        commentCount: json['comment_counter'] ?? 0,
        likedByUser: json['liked'] ?? false,
        totalReactionsCount: json['total_reaction_count'] ?? 0,
        userReaction: json['user_reaction'],
        reactionList: json["reactions_list"] == null
            ? []
            : (json["reactions_list"] as List)
                .map((x) => ReactionModel.fromJson(x))
                .toList(),
        topReactions: json["top_3_reactions"] == null
            ? []
            : (json["top_3_reactions"] as List)
                .map((x) => ReactionModel.fromJson(x))
                .toList(),
        reactionListCount: json["reaction_list_count"] == null
            ? []
            : (json["reaction_list_count"] as List)
                .map((x) => ReactionModel.fromJson(x))
                .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'custom_user_id': customUserId,
      'profile_id': authorProfileId,
      'username': username,
      'avatar': authorAvatar,
      'image': image,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'like_counter': likeCount,
      'comment_counter': commentCount,
      'liked': likedByUser,
    };
  }

  PostModel copyWith(
      {int? id,
      int? customUserId,
      int? authorProfileId,
      String? username,
      String? authorAvatar,
      String? image,
      String? content,
      DateTime? createdAt,
      DateTime? updatedAt,
      int? likeCount,
      int? commentCount,
      bool? likedByUser,
      String? userReaction,
      List<ReactionModel>? reactionList,
      List<ReactionModel>? topReactions,
      List<ReactionModel>? reactionListCount,
      int? totalReactionsCount}) {
    return PostModel(
        id: id ?? this.id,
        authorProfileId: authorProfileId ?? this.authorProfileId,
        customUserId: customUserId ?? this.customUserId,
        username: username ?? this.username,
        authorAvatar: authorAvatar ?? this.authorAvatar,
        image: image ?? this.image,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
        likedByUser: likedByUser ?? this.likedByUser,
        reactionList: reactionList ?? this.reactionList,
        reactionListCount: reactionListCount ?? [],
        topReactions: topReactions ?? [],
        totalReactionsCount: totalReactionsCount ?? 0,
        userReaction: userReaction);
  }

  @override
  bool operator ==(covariant PostModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customUserId == customUserId &&
        other.authorProfileId == authorProfileId &&
        other.username == username &&
        other.authorAvatar == authorAvatar &&
        other.image == image &&
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
        image.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        likeCount.hashCode ^
        commentCount.hashCode ^
        likedByUser.hashCode;
  }
}

class ReactionModel extends Equatable {
  String? userName;
  String? reactionType;
  late int count;
  DateTime? createAt;
  ReactionModel.fromJson(Map<String, dynamic> json) {
    userName = json["user"];
    reactionType = json["reaction_type"].toString().trim().toLowerCase();
    count = json["count"] == null ? 0 : json["count"];
    createAt = json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] ?? '');
  }
  ReactionModel(
      {this.userName, this.reactionType, this.count = 0, this.createAt});

  @override
  // TODO: implement props
  List<Object?> get props => [userName, reactionType];
}
