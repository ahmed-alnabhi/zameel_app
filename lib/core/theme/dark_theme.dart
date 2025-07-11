import 'package:flutter/material.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColorDark,
    onPrimary: AppColors.textColorDarkModePrimary,
    onSecondary: AppColors.textColorDarkModeSecondary,
    onSecondaryContainer: AppColors.textColorLightModePrimary,
    onTertiaryContainer: AppColors.textColorLightModePrimary,
    onTertiary: AppColors.iconTextFieldColorDarkMode,
    onSurface: Colors.white,
  ),

  scaffoldBackgroundColor: AppColors.backgroundColorDark,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.textColorDarkModePrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.textColorDarkModeSecondary,
    ),
    displaySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.primaryColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.textColorDarkModePrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.textColorLightModeSecondary,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.7),
      disabledForegroundColor: AppColors.textButtonColor.withValues(alpha: 0.7),
    ),
  ),
);
