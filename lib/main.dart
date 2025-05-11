import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode currentTheme = ThemeMode.system;

  dynamic changeTheme() {
    return () {
      setState(() {
        if (currentTheme == ThemeMode.light) {
          currentTheme = ThemeMode.dark;
        } else {
          currentTheme = ThemeMode.light;
        }
      });
    };
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: currentTheme,
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryColor,
                secondary: AppColors.secondaryColor,
                onPrimary: AppColors.textColorLightModePrimary,
                onSecondary: AppColors.textColorLightModeSecondary,
                onSurface: Colors.white,
              ),
              scaffoldBackgroundColor: AppColors.backgroundColor,
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textColorLightModePrimary,
                ),
                displayMedium: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorLightModeSecondary,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: ColorScheme.dark(
                primary: AppColors.primaryColorDark,
                secondary: AppColors.secondaryColorDark,
                onPrimary: AppColors.textColorDarkModePrimary,
                onSecondary: AppColors.textColorDarkModeSecondary,
                onSurface: Colors.white,
              ),
              scaffoldBackgroundColor: AppColors.backgroundColorDark,
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.mainFontName,
                  color: AppColors.textColorDarkModePrimary,
                ),
                displayMedium: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorDarkModeSecondary,
                ),
              ),
            ),
            home: MyHomePage(themeChange: changeTheme()),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function() themeChange;
  const MyHomePage({super.key, required this.themeChange});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(15))),
    );
  }
}
