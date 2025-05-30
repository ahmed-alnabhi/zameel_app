import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/screens/home/assignments_screen.dart';
import 'package:zameel/screens/home/post_screen.dart';
import 'package:zameel/screens/home/profile_screen.dart';
import 'package:zameel/screens/home/resources_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; 


  List pages = [
    PostsScreen(),
    ResourcesScreen(),
    AssignmentsScreen(),
    AssignmentsScreen(),
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

              //      SizedBox(height: 5),
            ],
          ),
        ),
        body: pages[_currentIndex],
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index != 2) setState(() => _currentIndex = index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              iconSize: 24,
              selectedFontSize: 12,
              unselectedFontSize: 10,
              selectedItemColor: AppColors.primaryColor,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.home),
                  label: 'الصفحة الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.folder),
                  label: 'الملفات',
                ),
                BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.listTodo),
                  label: 'الإشعارات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(LucideIcons.user2),
                  label: 'الملف الشخصي',
                ),
              ],
            ),

           
            Positioned(
              bottom: 20,
              child: IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/icon.png", height: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
