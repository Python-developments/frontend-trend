class NotificationModel {
  int? id;
  int? userId;
  int? postId;
  String? senderUsername;
  int? senderUserId;
  String? senderAvatar;
  String? notificationType;
  String? createdAt;
  bool? isRead;
  String? reactionType;
  bool? followNotification;

  NotificationModel(
      {this.id,
      this.userId,
      this.postId,
      this.senderUsername,
      this.senderUserId,
      this.senderAvatar,
      this.notificationType,
      this.createdAt,
      this.isRead,
      this.reactionType,
      this.followNotification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    postId = json['post_id'];
    senderUsername = json['sender_username'];
    senderUserId = json['sender_user_id'];
    senderAvatar = json['sender_avatar'];
    notificationType = json['notification_type'];
    createdAt = json['created_at'];
    isRead = json['is_read'];
    reactionType = json['reaction_type'];
    followNotification = json['follow_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['sender_username'] = this.senderUsername;
    data['sender_user_id'] = this.senderUserId;
    data['sender_avatar'] = this.senderAvatar;
    data['notification_type'] = this.notificationType;
    data['created_at'] = this.createdAt;
    data['is_read'] = this.isRead;
    data['reaction_type'] = this.reactionType;
    data['follow_notification'] = this.followNotification;
    return data;
  }
}
