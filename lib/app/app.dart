import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/features/posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import 'package:frontend_trend/features/profile/presentation/bloc/current_user_cubit/current_user_cubit.dart';
import 'package:get/get.dart';
import '../config/locale/app_localizations.dart';
import '../config/locale/localization_cubit/localization_cubit.dart';
import '../config/routes/app_routes.dart';
import '../core/bloc/theme_cubit/theme_cubit.dart';
import '../injection_container.dart' as di;

class TrendApp extends StatelessWidget {
  const TrendApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<LocalizationCubit>()),
        BlocProvider(create: (context) => di.sl<ThemeCubit>()),
        BlocProvider(create: (context) => di.sl<PostsBloc>()),
        BlocProvider(create: (context) => di.sl<CurrentUserCubit>()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return BlocBuilder<LocalizationCubit, Locale>(
                  builder: (context, locale) {
                    return GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      home: MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        routerConfig: router,
                        title: 'Trend',
                        theme: ThemeData(
                            appBarTheme: AppBarTheme(
                                backgroundColor: Colors.white,
                                iconTheme: IconThemeData(color: Colors.black),
                                titleTextStyle: TextStyle(color: Colors.black)),
                            primaryColor: Colors.white,
                            scaffoldBackgroundColor: Colors.white),
                        themeMode: ThemeMode.light,
                        supportedLocales: const [
                          Locale('en'),
                          Locale('ar'),
                        ],
                        localizationsDelegates: const [
                          AppLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        localeResolutionCallback: (locale, supportedLocales) {
                          for (var supportedLocal in supportedLocales) {
                            if (supportedLocal.languageCode ==
                                locale!.languageCode) {
                              return supportedLocal;
                            }
                          }
                          return supportedLocales.first;
                        },
                        locale: locale,
                      ),
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
