import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_trend/features/chat/chat_user.dart';
import 'package:frontend_trend/features/chat/list_users.dart';
import 'package:frontend_trend/features/new_post/new_post.dart';
import 'package:frontend_trend/features/notifications/presentation/bloc/not_bloc/not_bloc.dart';
import 'package:frontend_trend/features/notifications/presentation/pages/notification_page.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/profile_posts_bloc.dart';
import 'package:frontend_trend/features/posts/presentation/pages/posts_page_profile.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/block_user_cubit/block_user_cubit.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:frontend_trend/features/profile/presentation/pages/edit_bio.dart';
import 'package:frontend_trend/features/profile/presentation/pages/follow_tap/follow_tap.dart';
import 'package:frontend_trend/features/profile/presentation/pages/sanad_block.dart';
import 'package:go_router/go_router.dart';

import '../../features/posts/presentation/pages/explore_page.dart';
import '../../features/posts/presentation/pages/single_post_page.dart';
import '../../features/posts/presentation/pages/taken_media_preview_page.dart';
import '../../features/profile/presentation/bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import '../../features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import '../../features/profile/presentation/pages/edit_profile.dart';
import '../../features/profile/presentation/pages/profile_following_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/vlogs/presentation/bloc/vlogs_bloc/vlogs_bloc.dart';
import '../../features/vlogs/presentation/pages/single_vlog_page.dart';
import '../../core/utils/shared_pref.dart';
import '../../features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import '../../features/authentication/presentation/pages/check_code_page.dart';
import '../../features/authentication/presentation/pages/confirm_forget_password_page.dart';
import '../../features/authentication/presentation/pages/forget_password_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/home/presentation/pages/home_initial_page.dart';
import '../../features/home/presentation/pages/home_navigator.dart';
import '../../features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import '../../features/posts/presentation/pages/camera_page.dart';
import '../../features/posts/presentation/pages/posts_page.dart';
import '../../features/profile/presentation/bloc/get_profile_followers_bloc/get_profile_followers_bloc.dart';
import '../../features/profile/presentation/pages/profile_followers_page.dart';
import '../../features/vlogs/presentation/pages/taken_vlog_preview_page.dart';
import '../../features/vlogs/presentation/pages/vlogs_page.dart';
import '../../injection_container.dart';
import '../locale/app_localizations.dart';

class Routes {
  static String initialPage = '/';
  static String notificationPage = '/notifications';
  // static String editBio = '/editBio';

  static String posts = '/posts';

  static String userProfile = '/posts/user';
  static String chatUser = '/chatUser';

  static String explore = '/explore';
  static String blockPage = '/getAllBlocksPage';
  static String chatPage = '/chatscreen';
  static String postDetails(int id) => '/explore/post/$id';
  static String profileDetails(int id) => '/vlogs/profile/$id';

  static String camera = '/camera';
  static String takenMediaPreview = '/camera/preview';
  static String takenVlogPreview = '/vlogs/preview';
  static String vlogs = '/vlogs';
  static String newPost = '/newpost';
  static String vlogDetails(int id) => '/profile/vlog/$id';

  static String profile = '/profile';
  static String profileFollowing(int id) => '/profile/$id/following';
  static String profileFollowers(int id) => '/profile/$id/followers';
  static String sanadProfileFollowers(int id) => '/profile/$id/sanadfollowers';

  static String settings = '/profile/settings';
  static String editProfile = '/profile/edit';

  static String login = '/login';
  static String signUp = '/login/signUp';
  static String forgetPassword = '/login/forgetPassword';
  static String checkCode(String email) => '$login/checkCode/$email';
  static String confirmForgetPassword(String email, String code) =>
      '$login/confirmForgetPassword/$email/$code';
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final SharedPref _sharedPref = sl<SharedPref>();

void logout() async {
  try {
    await _sharedPref.clear();
  } catch (e) {
    debugPrint(e.toString());
  }

  router.go(Routes.login);
}

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.initialPage,
  routes: [
    /* GoRoute(
      path: "/editBio",
      pageBuilder: (context, state) => NoTransitionPage(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<CurrentUserCubit>()),
            BlocProvider(create: (context) => sl<ProfileBloc>())
          ],
          child: EditBio(
            profile: (state.extra as Map)["profile"]!,
            changedBio: (state.extra as Map)["fun"],
          ),
        ),
      ),
    ),
    */
    GoRoute(
      path: Routes.initialPage,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomeInitialPage()),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<ProfileBloc>()),
          BlocProvider(create: (context) => sl<VlogsBloc>()),
          BlocProvider(create: (context) => sl<BlockUserCubit>()),
          BlocProvider(
              create: (context) => sl<CurrentUserCubit>()..fetchCurrentUser()),
        ],
        child: HomeNavigator(
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: Routes.newPost,
          pageBuilder: (context, state) => NoTransitionPage(
              child: AddNewPostPage(
            function: (state.extra as Map)["function"],
          )),
        ),
        GoRoute(
          path: Routes.posts,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PostsPage(),
          ),
          routes: [
            GoRoute(
                path: "user",
                pageBuilder: (context, state) => NoTransitionPage(
                      child: ProfilePage(
                        profileId:
                            int.parse((state.extra as Map)["profileid"]!),
                      ),
                    ),
                routes: const []),
          ],
        ),
        GoRoute(
          path: '/userposts',
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (context) => sl<ProfilePostsBloc>(),
              child: PostsUserPage(
                index: (state.extra as Map)["index"],
                posts: (state.extra as Map)["posts"],
                userId: (state.extra as Map)["userId"],
              ),
            ),
          ),
          routes: [
            GoRoute(
                path: "user",
                pageBuilder: (context, state) => NoTransitionPage(
                      child: ProfilePage(
                        profileId:
                            int.parse((state.extra as Map)["profileid"]!),
                      ),
                    ),
                routes: const []),
          ],
        ),
        GoRoute(
          path: Routes.vlogs,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: VlogsPage(),
          ),
          routes: [
            GoRoute(
              path: 'profile/:profileid',
              redirect: (context, state) {
                if (int.tryParse(state.pathParameters['profileid'] ?? '') ==
                    null) {
                  return Routes.explore;
                }
                return null;
              },
              pageBuilder: (context, state) => SlideTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<ProfileBloc>(),
                  child: ProfilePage(
                      profileId:
                          int.parse(state.pathParameters['profileid'] ?? '')),
                ),
              ),
            ),
            GoRoute(
                path: "preview",
                pageBuilder: (context, state) => NoTransitionPage(
                      child: TakenVlogPreviewPage(
                        files: (state.extra as Map)["files"],
                      ),
                    )),
          ],
        ),
        GoRoute(
            path: Routes.explore,
            pageBuilder: (context, state) => const NoTransitionPage(
                  child: ExplorePage(),
                ),
            routes: [
              GoRoute(
                path: 'post/:id',
                redirect: (context, state) {
                  if (int.tryParse(state.pathParameters['id'] ?? '') == null) {
                    return Routes.explore;
                  }
                  return null;
                },
                pageBuilder: (context, state) => SlideTransitionPage(
                  child: SinglePostPage(
                      postId: int.parse(state.pathParameters['id'] ?? '')),
                ),
              ),
            ]),
        GoRoute(
          path: "/preview",
          pageBuilder: (context, state) => NoTransitionPage(
            child: TakenMediaPreviewPage(
              files: (state.extra as Map)["files"],
              mediaType: (state.extra as Map)["mediaType"],
            ),
          ),
        ),
        GoRoute(
          path: Routes.camera,
          pageBuilder: (context, state) => NoTransitionPage(
            child: CameraPage(
              isVlog: ((state.extra as Map?)?['isVlog'] as bool?) ?? false,
            ),
          ),
          routes: [
            GoRoute(
                path: "preview",
                pageBuilder: (context, state) => NoTransitionPage(
                      child: TakenMediaPreviewPage(
                        files: (state.extra as Map)["files"],
                        mediaType: (state.extra as Map)["mediaType"],
                      ),
                    )),
          ],
        ),
        GoRoute(
          path: Routes.profile,
          pageBuilder: (context, state) => SlideTransitionPage(
            child: BlocProvider(
              create: (context) => sl<VlogsBloc>(),
              child: ProfilePage(
                profileId: sl<SharedPref>().account!.profileId,
              ),
            ),
          ),
          routes: [
            GoRoute(
              path: 'vlog/:id',
              redirect: (context, state) {
                if (int.tryParse(state.pathParameters['id'] ?? '') == null) {
                  return Routes.profile;
                }
                return null;
              },
              pageBuilder: (context, state) => SlideTransitionPage(
                child: BlocProvider.value(
                  value: state.extra as VlogsBloc,
                  child: SingleVlogPage(
                      vlogId: int.parse(state.pathParameters['id'] ?? '')),
                ),
              ),
            ),
            GoRoute(
              path: ':id/following',
              redirect: (context, state) {
                if (int.tryParse(state.pathParameters['id'] ?? '') == null) {
                  return Routes.explore;
                }
                return null;
              },
              pageBuilder: (context, state) => SlideTransitionPage(
                child: BlocProvider(
                  create: (context) => sl<GetProfileFollowingBloc>(),
                  child: ProfileFollowingPage(
                      profileId: int.parse(state.pathParameters['id'] ?? '')),
                ),
              ),
            ),
            GoRoute(
              path: ':id/sanadfollowers',
              redirect: (context, state) {
                if (int.tryParse(state.pathParameters['id'] ?? '') == null) {
                  return Routes.explore;
                }
                return null;
              },
              pageBuilder: (context, state) => SlideTransitionPage(
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => sl<GetProfileFollowersBloc>()),
                    BlocProvider(
                        create: (context) => sl<GetProfileFollowingBloc>()),
                  ],
                  child: FollowTabs(
                    profileId: int.parse(state.pathParameters['id'] ?? ''),
                    name: (state.extra as Map)["name"],
                    tabIndex: 0,
                  ),
                ),
              ),
            ),
            GoRoute(
              path: "edit",
              pageBuilder: (context, state) => NoTransitionPage(
                child: EditProfilePage(
                  profile: (state.extra as Map)["profile"]!,
                ),
              ),
            ),
            GoRoute(
              path: "settings",
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsPage(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: Routes.notificationPage,
          pageBuilder: (context, state) => NoTransitionPage(
              child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) => sl<NotBloc>()),
          ], child: NotificationsPage())),
        ),
      ],
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: LoginPage(),
            ),
        routes: [
          GoRoute(
            path: 'forgetPassword',
            pageBuilder: (context, state) => SlideTransitionPage(
                child: BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: const ForgetPasswordPage(),
            )),
          ),
          GoRoute(
            path: 'checkCode/:email',
            redirect: (context, state) {
              if (state.pathParameters['email'] == null) {
                return Routes.login;
              }
              return null;
            },
            pageBuilder: (context, state) => SlideTransitionPage(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<AuthBloc>(),
                  ),
                ],
                child: CheckCodePage(email: state.pathParameters['email']!),
              ),
            ),
          ),
          GoRoute(
            path: 'confirmForgetPassword/:email/:code',
            redirect: (context, state) {
              if (state.pathParameters['email'] == null ||
                  state.pathParameters['code'] == null) {
                return Routes.login;
              }
              return null;
            },
            pageBuilder: (context, state) => SlideTransitionPage(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<AuthBloc>(),
                  ),
                ],
                child: ConfirmForgetPasswordPage(
                  email: state.pathParameters['email']!,
                  code: state.pathParameters['code']!,
                ),
              ),
            ),
          ),
          GoRoute(
            path: 'signUp',
            pageBuilder: (context, state) => SlideTransitionPage(
                child: BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: const RegisterPage(),
            )),
          ),
        ]),
    GoRoute(
      path: "/getAllBlocksPage",
      pageBuilder: (context, state) => NoTransitionPage(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<BlockUserCubit>()),
          ],
          child: GetAllBlocksPage(),
        ),
      ),
    ),
    GoRoute(
      path: "/chatUser",
      pageBuilder: (context, state) => NoTransitionPage(
        child: ChatUser(),
      ),
    ),
    GoRoute(
      path: "/chatscreen",
      pageBuilder: (context, state) => NoTransitionPage(
        child: ChatScreen(),
      ),
    ),
  ],
  redirect: (context, state) {
    if (!state.uri.toString().startsWith('/login') && !_sharedPref.isLoggedIn) {
      return '/login';
    }

    return null;
  },
  errorPageBuilder: (context, state) =>
      const NoTransitionPage(child: PageNotFound()),
);

class PageNotFound extends StatelessWidget {
  const PageNotFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    Navigator.pop(context);
                  } else {
                    context.go(Routes.posts);
                  }
                },
                child: Text(GoRouter.of(context).canPop()
                    ? 'Back'.hardcoded
                    : 'Home'.hardcoded),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SlideTransitionPage<T> extends CustomTransitionPage<T> {
  const SlideTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
          transitionsBuilder: _transitionsBuilder,
          transitionDuration: const Duration(milliseconds: 300),
        );

  static Widget _transitionsBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    final begin = AppLocalizations.of(context)!.isRTL
        ? const Offset(-1.0, 0.0)
        : const Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: tween.animate(animation),
      child: child,
    );
  }
}
