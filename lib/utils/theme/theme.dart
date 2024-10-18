import 'package:flutter/material.dart';
import 'package:unisport_player_app/utils/const/colors.dart';
import 'package:unisport_player_app/utils/theme/custom_theme/input_decoration_.dart';
import 'package:unisport_player_app/utils/theme/custom_theme/tabbar_theme.dart';

import '../const/sizes.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/text_theme.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: AppColors.kPrimary)),
      scaffoldBackgroundColor: AppColors.kwhite,
      brightness: Brightness.light,
      colorSchemeSeed: AppColors.kPrimary,
      useMaterial3: true,
      textTheme: AppTextTheme.lighttextTheme,
      tabBarTheme: AppTabbarTheme.lightTabbar(context),
      inputDecorationTheme: AppInputDecoration.textFieldDecoration,
      elevatedButtonTheme: AppElevatedButton.buttonTheme,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent, elevation: 0),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.md))),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, elevation: 0, iconTheme: IconThemeData(color: AppColors.kPrimary)),
      scaffoldBackgroundColor: AppColors.kblack,
      brightness: Brightness.dark,
      useMaterial3: true,
      colorSchemeSeed: AppColors.kPrimary,
      textTheme: AppTextTheme.darktextTheme,
      tabBarTheme: AppTabbarTheme.darkTabbar(context),
      inputDecorationTheme: AppInputDecoration.darktextFieldDecoration,
      elevatedButtonTheme: AppElevatedButton.buttonTheme,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent, elevation: 0),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.md))),
      ),
    );
  }
}
