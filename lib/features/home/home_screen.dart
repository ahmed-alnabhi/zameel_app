import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/features/home/assignments_screen.dart';
import 'package:zameel/features/home/chat_bot/chat_screen.dart';
import 'package:zameel/features/home/posts/post_screen.dart';
import 'package:zameel/features/home/profile/profile_screen.dart';
import 'package:zameel/features/home/resources/resources_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _Homefeaturestate();
}

class _Homefeaturestate extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    PostsScreen(),
    ResourcesScreen(),
    AssignmentsScreen(),
    AssignmentsScreen(), // one extra for the empty middle space
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          toolbarHeight: 60,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Column(
            children: [
              SvgPicture.asset("assets/images/logo.svg", height: 55, width: 88),
              SizedBox(height: 6),
            ],
          ),
        ),
        body: IndexedStack(index: _currentIndex, children: pages),
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index != 2) {
                  setState(() {
                    _currentIndex = index;
                  });
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  Theme.of(context).colorScheme.onSecondaryContainer,
              iconSize: 24,
              selectedFontSize: 12,
              unselectedFontSize: 10,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.home),
                  activeIcon: SvgPicture.asset(
                    "assets/images/taps/house.svg",
                    height: 28,
                    width: 28,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'الصفحة الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.folder),
                  activeIcon: SvgPicture.asset(
                    "assets/images/taps/folder.svg",
                    height: 26,
                    width: 26,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'الملفات',
                ),
                BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.listTodo),
                  activeIcon: Icon(LucideIcons.listTodo),
                  label: 'التكاليف',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.user),
                  activeIcon: SvgPicture.asset(
                    "assets/images/taps/user.svg",
                    height: 26,
                    width: 26,
                    colorFilter: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: 'الملف الشخصي',
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ChatScreen(),
                  ));
                },
                icon: Image.asset("assets/images/icon.png", height: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
