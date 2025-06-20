import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/theme/dark_theme.dart';
import 'package:zameel/core/theme/light_theme.dart';
import 'package:zameel/features/authentication/login_screen.dart';


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
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: currentTheme,
            theme:   lightTheme ,
            darkTheme:  darkTheme,
            home:  LoginScreen()
          ),
    );
  }
}
