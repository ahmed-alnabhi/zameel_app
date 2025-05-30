import 'package:flutter/material.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    onPrimary: AppColors.textColorLightModePrimary,
    onSecondary: AppColors.textColorLightModeSecondary,
    onSecondaryContainer: AppColors.primaryLightColor,
    onTertiaryContainer: AppColors.containerColor,
     onTertiary: AppColors.textColorLightModeSecondary,
    onSurface: Colors.white,
    
  ),
  scaffoldBackgroundColor: AppColors.backgroundColor,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontFamily: AppFonts.mainFontName,
      fontWeight: FontWeight.w700,
      color: AppColors.textColorLightModePrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.textColorLightModeSecondary,
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
      color: AppColors.textColorLightModePrimary,
    ) ,
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.mainFontName,
      color: AppColors.textColorLightModeSecondary,
    ) ,
    
  ),              
   elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      disabledBackgroundColor: AppColors.primaryColor.withValues(alpha: 0.7),
      disabledForegroundColor: AppColors.textButtonColor.withValues(alpha: 0.7),
    ),
  ),
);
