import 'package:dio/dio.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/profile_posts_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_trend/features/notifications/data/data_source/nots_remote_data_source.dart';
import 'package:frontend_trend/features/notifications/data/repository/nots_repository.dart';
import 'package:frontend_trend/features/notifications/data/repository/nots_repository_impl.dart';
import 'package:frontend_trend/features/notifications/presentation/bloc/not_bloc/not_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/block_user_cubit/block_user_cubit.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'core/bloc/theme_cubit/theme_cubit.dart';
import 'features/posts/data/repository/posts_repository.dart';
import 'features/posts/data/repository/posts_repository_impl.dart';
import 'features/posts/presentation/bloc/comments_bloc/comments_bloc.dart';
import 'features/posts/presentation/bloc/get_likes_users_by_post_bloc/get_likes_users_by_post_bloc.dart';
import 'features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'config/locale/localization_cubit/localization_cubit.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/network/network_info.dart';
import 'core/repositories/repository_handler.dart';
import 'core/utils/shared_pref.dart';
import 'features/authentication/data/data_source/auth_remote_data_source.dart';
import 'features/authentication/data/repository/auth_repository.dart';
import 'features/authentication/data/repository/auth_repository_impl.dart';
import 'features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'features/posts/data/data_source/posts_remote_data_source.dart';
import 'features/profile/data/data_source/profile_remote_data_source.dart';
import 'features/profile/data/repository/profile_repository.dart';
import 'features/profile/data/repository/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/get_profile_followers_bloc/get_profile_followers_bloc.dart';
import 'features/profile/presentation/bloc/get_profile_following_bloc/get_profile_following_bloc.dart';
import 'features/vlogs/data/data_source/vlogs_remote_data_source.dart';
import 'features/vlogs/data/repository/vlogs_repository.dart';
import 'features/vlogs/data/repository/vlogs_repository_impl.dart';
import 'features/vlogs/presentation/bloc/vlog_comments_bloc/vlog_comments_bloc.dart';
import 'features/vlogs/presentation/bloc/vlogs_bloc/vlogs_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  _initAuth();
  _initNotifications();
  _initProfile();
  _initPosts();
  _initVlogs();

  await _registerCoreAndExternal();
}

void _initProfile() {
  //bloc

  sl.registerFactory(() => CurrentUserCubit(sl(), sl()));
  sl.registerFactory(() => BlockUserCubit(profileRepository: sl()));
  sl.registerFactory(() => ProfilePostsBloc(postsRepository: sl()));
  sl.registerFactory(() => ProfileBloc(
        profileRepository: sl(),
      ));
  sl.registerFactory(() => GetProfileFollowingBloc(
        profileRepository: sl(),
      ));
  sl.registerFactory(() => GetProfileFollowersBloc(
        profileRepository: sl(),
      ));

  //repositories
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
        profileRemoteDataSource: sl(),
        networkInfo: sl(),
        sharedPref: sl(),
        repositoryHandler: sl(),
      ));

  //data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
            apiConsumer: sl(),
          ));
}

void _initPosts() {
  //bloc
  sl.registerFactory(() => PostsBloc(
        postsRepository: sl(),
      ));

  sl.registerFactory(() => CommentsBloc(
        postsRepository: sl(),
      ));
  sl.registerFactory(() => GetLikesUsersByPostBloc(
        postsRepository: sl(),
      ));
  //repositories
  sl.registerLazySingleton<PostsRepository>(() => PostsRepositoryImpl(
        postsRemoteDataSource: sl(),
        networkInfo: sl(),
        sharedPref: sl(),
        repositoryHandler: sl(),
      ));

  //data sources
  sl.registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImpl(
            apiConsumer: sl(),
            sharedPref: sl(),
          ));
}

void _initNotifications() {
  sl.registerFactory(() => NotBloc(
        postsRepository: sl(),
      ));
  sl.registerLazySingleton<NotificationsRepository>(() => NotsRepositoryImpl(
        postsRemoteDataSource: sl(),
        networkInfo: sl(),
        sharedPref: sl(),
        repositoryHandler: sl(),
      ));
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
      () => NotsRemoteDataSourceImpl(
            apiConsumer: sl(),
            sharedPref: sl(),
          ));
}

void _initVlogs() {
  //bloc
  sl.registerFactory(() => VlogsBloc(
        vlogsRepository: sl(),
      ));
  sl.registerFactory(() => VlogCommentsBloc(
        vlogsRepository: sl(),
      ));

  //repositories
  sl.registerLazySingleton<VlogsRepository>(() => VlogsRepositoryImpl(
        vlogsRemoteDataSource: sl(),
        networkInfo: sl(),
        sharedPref: sl(),
        repositoryHandler: sl(),
      ));

  //data sources
  sl.registerLazySingleton<VlogsRemoteDataSource>(
      () => VlogsRemoteDataSourceImpl(
            apiConsumer: sl(),
            sharedPref: sl(),
          ));
}

void _initAuth() {
  //bloc
  sl.registerFactory(() => AuthBloc(
        authRepository: sl(),
      ));

  //repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSource: sl(),
        networkInfo: sl(),
        sharedPref: sl(),
        repositoryHandler: sl(),
      ));

  //data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiConsumer: sl()));
}

Future<void> _registerCoreAndExternal() async {
  //! Core
  sl.registerFactory(() => LocalizationCubit(sharedPref: sl()));
  sl.registerFactory(() => ThemeCubit(sharedPref: sl()));
  sl.registerLazySingleton(() => SharedPref(sharedPreferences: sl()));

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton<RepositoryHandler>(() => RepositoryHandlerImpl());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(
      () => AppIntercepters(sharedPref: sl(), client: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
