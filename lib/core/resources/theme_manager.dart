import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_manager.dart';

_inputBorder([Color color = kLightBorderColor]) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.sp),
      borderSide: BorderSide(color: color));
}

ThemeData get appTheme => ThemeData(
    fontFamily: 'Inter',
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kMainColor,
      primary: kMainColor,
      brightness: Brightness.light,
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.sp),
      ),
    ),
    secondaryHeaderColor: kMainTextColor,
    dividerColor: kDividerColor,
    disabledColor: kLightBorderColor,
    hintColor: kHintColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.sp),
          ),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: TextStyle(fontSize: 16.sp),
      hintStyle: TextStyle(
          fontSize: 15.sp,
          color: kLightBorderColor,
          fontWeight: FontWeight.w400),
      labelStyle: TextStyle(
          fontSize: 15.sp,
          color: kLightBorderColor,
          fontWeight: FontWeight.w400),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      border: _inputBorder(),
      focusedBorder: _inputBorder(kMainColor),
      errorBorder: _inputBorder(kRedColor),
      enabledBorder: _inputBorder(),
      disabledBorder: _inputBorder(),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      actionsIconTheme: const IconThemeData(color: Colors.black),
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20.sp,
      ),
      elevation: 0.0,
    ),

    // text
    textTheme: TextTheme(
        bodySmall: const TextStyle(color: kGreyColor),
        bodyMedium: const TextStyle(color: Colors.black),
        bodyLarge: const TextStyle(color: kbuttonLight),
        headlineSmall: const TextStyle(color: kLightGreyColor),
        headlineLarge: const TextStyle(color: Colors.white),
        displayLarge: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18.sp, color: Colors.black),
        headlineMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: kHeadlineMediumColor)));

ThemeData get darkTheme => ThemeData.dark(useMaterial3: true).copyWith(
      brightness: Brightness.dark,
      primaryColor: kMainColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kMainColor,
        brightness: Brightness.dark,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xff18191A),
      cardColor: const Color(0xff1b1b1b),
      cardTheme: CardTheme(
        color: const Color(0xff1b1b1b),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      hintColor: kHintColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kMainColor,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: const Color(0xff18191A),
        iconTheme: IconThemeData(color: Colors.white.withOpacity(0.5)),
        actionsIconTheme: IconThemeData(color: Colors.white.withOpacity(0.5)),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // text
      textTheme: TextTheme(
        bodySmall: const TextStyle(color: kGreyColor, fontFamily: "Inter"),
        bodyMedium:
            const TextStyle(color: kIconsDarkColor, fontFamily: "Inter"),
        bodyLarge: const TextStyle(color: kbuttonDark, fontFamily: "Inter"),
        headlineSmall:
            const TextStyle(color: kDarkGreyColor, fontFamily: "Inter"),
        headlineLarge:
            const TextStyle(color: kDarkBottomNavColor, fontFamily: "Inter"),
        displayLarge: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 18.sp, color: Colors.white),
        headlineMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: kHeadlineMediumColor),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kbuttonDark,
        floatingLabelStyle: TextStyle(fontSize: 16.sp),
        hintStyle: TextStyle(
            fontSize: 15.sp,
            color: kLightBorderColor,
            fontWeight: FontWeight.w400),
        labelStyle: TextStyle(
            fontSize: 15.sp,
            color: kLightBorderColor,
            fontWeight: FontWeight.w400),
        isDense: true,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
        border: _inputBorder(kDarkGreyColor),
        focusedBorder: _inputBorder(kMainColor),
        errorBorder: _inputBorder(kRedColor),
        enabledBorder: _inputBorder(kDarkGreyColor),
        disabledBorder: _inputBorder(kDarkGreyColor),
      ),
    );
