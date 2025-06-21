import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/theme/dark_theme.dart';
import 'package:zameel/core/theme/light_theme.dart';
import 'package:zameel/features/authentication/login_screen.dart';


void main() {
  runApp(const MyApp());
}
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return ScreenUtilInit(
          designSize: const Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: currentTheme,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const LoginScreen(),
          ),
        );
      },
    );
  }
}
