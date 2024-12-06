import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/shared_pref.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPref sharedPref;

  ThemeCubit({required this.sharedPref}) : super(sharedPref.themeMode);

  void changeMode(ThemeMode mode) {
    emit(mode);
    sharedPref.setThemeMode(mode);
  }

  bool isLightMode(BuildContext context) {
    if (state == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.light;
    }

    return state == ThemeMode.light;
  }
}
