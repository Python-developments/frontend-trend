import 'dart:developer';

import '../../../../core/utils/entities/paged_list.dart';
import '../../../posts/data/models/post_model.dart';
import '../../../../core/utils/entities/pagination_param.dart';

class ProfileModel {
  final int id;
  final int postsCount;
  final int vlogsCount;
  final int followingCount;
  final int followersCount;
  final int reactionCount;
  final String username;
  final String fName;
  final String lName;
  final String location;
  final String phone;
  final String avatar;
  final String backgroundImage;
  final String bio;
  final String mail;
  final bool isFollowing;
  final PagedList<PostModel> posts;

  ProfileModel({
    required this.id,
    required this.username,
    required this.avatar,
    required this.backgroundImage,
    required this.bio,
    required this.fName,
    required this.lName,
    required this.location,
    required this.phone,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.vlogsCount,
    required this.posts,
    required this.mail,
    required this.isFollowing,
    required this.reactionCount,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> jsonData) {
    List<PostModel> posts = [];
    int? nextPage;
    if (jsonData.containsKey("user_posts") &&
        (jsonData['user_posts'] as List).isNotEmpty) {
      posts = (jsonData['user_posts'] as List)
          .map((jsonPost) => PostModel.fromJson(jsonPost))
          .toList();
    }

    return ProfileModel(
      id: jsonData.containsKey('id') && jsonData['id'] != null
          ? jsonData['id']
          : 0,
      username: jsonData.containsKey('username') && jsonData['username'] != null
          ? jsonData['username']
          : '',
      fName:
          jsonData.containsKey('first_name') && jsonData['first_name'] != null
              ? jsonData['first_name']
              : '',
      lName: jsonData.containsKey('last_name') && jsonData['last_name'] != null
          ? jsonData['last_name']
          : '',
      location: jsonData.containsKey('"locatio') && jsonData['"locatio'] != null
          ? jsonData['"locatio']
          : '',
      phone: jsonData.containsKey('"phone_numbe') &&
              jsonData['"phone_numbe'] != null
          ? jsonData['"phone_numbe']
          : '',
      mail: jsonData.containsKey('email') && jsonData['email'] != null
          ? jsonData['email']
          : '',
      avatar: jsonData.containsKey('avatar') && jsonData['avatar'] != null
          ? jsonData['avatar']
          : '',
      backgroundImage: jsonData.containsKey('background_pic') &&
              jsonData['background_pic'] != null
          ? jsonData['background_pic']
          : '',
      bio: jsonData.containsKey('bio') && jsonData['bio'] != null
          ? jsonData['bio']
          : '',
      postsCount:
          jsonData.containsKey('posts_count') && jsonData['posts_count'] != null
              ? jsonData['posts_count']
              : 0,
      vlogsCount:
          jsonData.containsKey('vlogs_count') && jsonData['vlogs_count'] != null
              ? jsonData['vlogs_count']
              : 0,
      followersCount: jsonData.containsKey('followers_count') &&
              jsonData['followers_count'] != null
          ? jsonData['followers_count']
          : 0,
      reactionCount: jsonData.containsKey('total_reactions') &&
              jsonData['total_reactions'] != null
          ? jsonData['total_reactions']
          : 0,
      followingCount: jsonData.containsKey('following_count') &&
              jsonData['following_count'] != null
          ? jsonData['following_count']
          : 0,
      isFollowing: jsonData.containsKey('is_following') &&
              jsonData['is_following'] != null
          ? jsonData['is_following']
          : false,
      posts: PagedList(items: posts, nextPageNumber: nextPage),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'avatar': avatar,
      'background_pic': backgroundImage,
      'bio': bio,
    };
  }

  ProfileModel copyWith(
      {int? id,
      int? postsCount,
      int? vlogsCount,
      int? followingCount,
      int? followersCount,
      String? username,
      String? avatar,
      String? backgroundImage,
      String? bio,
      String? fName,
      String? lName,
      String? location,
      String? phone,
      String? mail,
      bool? isFollowing,
      PagedList<PostModel>? posts,
      int? reactionCount}) {
    return ProfileModel(
      id: id ?? this.id,
      postsCount: postsCount ?? this.postsCount,
      vlogsCount: vlogsCount ?? this.vlogsCount,
      followingCount: followingCount ?? this.followingCount,
      followersCount: followersCount ?? this.followersCount,
      reactionCount: reactionCount ?? this.reactionCount,
      username: username ?? this.username,
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      bio: bio ?? this.bio,
      mail: mail ?? this.mail,
      isFollowing: isFollowing ?? this.isFollowing,
      posts: posts ?? this.posts,
    );
  }
}
