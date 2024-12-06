class EndPoints {
  // server
  // static const String baseUrl = 'https://3dkdxh3z-8000.euw.devtunnels.ms';
  static const String baseUrl = 'http://3.16.43.37';

  // for android emulator
  // static const String baseUrl = 'http://10.0.2.2:8000';

  // static const String baseUrl = 'http://127.0.0.1:8000';

  static const String mediaUrl = '$baseUrl/media/images';
// auth
  static const String login = '/auth/login/';
  static const String register = '/auth/register/';
  static const String generatePresignedUrl = '/uploads/generate-presigned-url/';
  static const String refreshToken = '/login/refresh/';

  static const String forgetPassword = '/auth/PasswordResetRequest/';
  static const String checkCode = '/password-reset/check-code/';
  static const String confirmPassword = '/password-reset/confirm/';
///////////////////////////////////////////
  ///
  static const String profile = '/profile/';
  static String editProfile(int id) => '$baseUrl/profile/$id/';
  static const String followUser = '$baseUrl/profile/follow/';
  static const String unFollowUser = '$baseUrl/profile/unfollow/';
  static String unBlockUser(int id) => '$baseUrl/auth/blocks/unblock/$id/';
  static const String blockUser = '$baseUrl/auth/blocks/create/';
  static const String blockList = '$baseUrl/auth/blocks/';
  static String profileFollowers(int profileId) =>
      '$baseUrl/profile/$profileId/followers/';
  static String profileFollowing(int profileId) =>
      '$baseUrl/profile/$profileId/following/';
  static String profileVlogs(int profileId) =>
      '$baseUrl/profile/$profileId/vlogs/';

  static const String addPost = '$baseUrl/post/createpost/';
  static const String addComment = '$baseUrl/post/createcomment/';
  static const String toggleLike = '$baseUrl/post/toggle-like/';
  static String toggleReaction(int id) => '$baseUrl/post/$id/toggle-reaction';
  static const String posts = '$baseUrl/post/posts-list/';
  static const String notifications = '$baseUrl/notification/';
  static const String postDetails = '$baseUrl/post/';
  static String deletePost(int id) => '$baseUrl/post/$id/delete/';
  static const String hidePost = '$baseUrl/post/hide-or-unhide-post/';
  static String postLikers(int id) => '$baseUrl/post/$id/likers/';

  static const String addVlog = '$baseUrl/vlog/videos/';
  static String addVlogComment(dynamic id) =>
      '$baseUrl/vlog/videos/$id/comments/';
  static String toggleVlogLike(dynamic id) => '$baseUrl/vlog/videos/$id/like/';
  static const String vlogs = '$baseUrl/vlog/videos/';
}
