// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/config/locale/app_localizations.dart';
import 'package:frontend_trend/config/locale/localization_cubit/localization_cubit.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/core/resources/assets_manager.dart';
import 'package:frontend_trend/core/resources/color_manager.dart';
import 'package:frontend_trend/core/utils/app_divider.dart';
import 'package:frontend_trend/core/utils/dialog_utils.dart';
import 'package:frontend_trend/core/utils/modal_sheet_utils.dart';
import 'package:frontend_trend/core/widgets/custom_tile.dart';
import '../../../../core/bloc/theme_cubit/theme_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".hardcoded),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SettingsTileWidget(
            //   title: "Language".hardcoded,
            //   onTap: () {
            //     _languageModal(context);
            //   },
            //   iconIAssetUrl: ImgAssets.languageIconSVG,
            // ),
            CustomTileWidget(
              title: "Theme".hardcoded,
              onTap: () {
                _themeModal(context);
              },
              iconIAssetUrl: ImgAssets.themeIconSVG,
            ),
            // SettingsTileWidget(
            //   title: "Private account".hardcoded,
            //   onTap: () {
            //
            //   },
            //   titleColor: kRedColor,
            // ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 4.sp),
              child: CustomTileWidget(
                title: "Logout".hardcoded,
                onTap: () async {
                  final result = await DialogUtils(context).showConfirmDialog(
                      titleText: "Logout confrim".hardcoded,
                      contentText: "Do you want to logout ?".hardcoded,
                      submitButtonText: "Logout".hardcoded,
                      submitButtonColor: kRedColor);

                  if (result != null && result is bool && result) {
                    logout();
                  }
                },
                titleColor: kRedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _themeModal(BuildContext context) {
    ModalSheetUtils(context).showCustomModalSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTileWidget(
            title: "Light Theme".hardcoded,
            onTap: () {
              context.read<ThemeCubit>().changeMode(ThemeMode.light);
            },
            iconIAssetUrl: ImgAssets.lightThemeIconSVG,
            showTrailing: false,
          ),
          const AppDivider(),
          CustomTileWidget(
            title: "Dark Theme".hardcoded,
            showTrailing: false,
            onTap: () {
              context.read<ThemeCubit>().changeMode(ThemeMode.dark);
            },
            iconIAssetUrl: ImgAssets.themeIconSVG,
          ),
          const AppDivider(),
        ],
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Theme'.hardcoded,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff616977),
              ),
            ),
          ],
        ),
      ),
      height: MediaQuery.sizeOf(context).height * .3.sp,
      assetImageUrl: ImgAssets.themeIconSVG,
    );
  }

  void _languageModal(BuildContext context) {
    ModalSheetUtils(context).showCustomModalSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTileWidget(
            title: "Arabic".hardcoded,
            onTap: () {
              context
                  .read<LocalizationCubit>()
                  .changeLanguage(const Locale("ar"));
            },
            showTrailing: false,
          ),
          const AppDivider(),
          CustomTileWidget(
            title: "English".hardcoded,
            showTrailing: false,
            onTap: () {
              context
                  .read<LocalizationCubit>()
                  .changeLanguage(const Locale("en"));
            },
          ),
          const AppDivider(),
        ],
      ),
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Theme'.hardcoded,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xff616977),
              ),
            ),
          ],
        ),
      ),
      height: MediaQuery.sizeOf(context).height * .3.sp,
      assetImageUrl: ImgAssets.languageIconSVG,
    );
  }
}
