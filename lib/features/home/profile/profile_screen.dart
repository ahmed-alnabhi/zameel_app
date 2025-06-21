import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/features/authentication/login_screen.dart';
import 'package:zameel/features/authentication/password_recovery/password_recovery_screen.dart';
import 'package:zameel/features/home/profile/change_theme.dart';
import 'package:zameel/features/home/profile/join_requests_screen.dart';
import 'package:zameel/features/home/profile/request_join_again/join_class_again_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? token; //"69|cC6OWhos3N3LHKeMkKOddDDdgBY6UZnL3Fdhtszx3f139e81";
  int? roll;
  String? email;
  String? name;
  String? groupName;
  int? groupId;
  bool isLoading = false;
  bool hasErorr = false;
  Future<void> _getInformationFromSheredPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    roll = prefs.getInt('roll');
    email = prefs.getString('email');
    name = prefs.getString('name');
    setState(() {});
    if (token != null) {
      final result = await fetchStudentGroups(token: token);
      if (result['success']) {
        setState(() {
          groupName = result['groupNames'].first ?? '';
          groupId = result['data'].first;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getInformationFromSheredPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: Text(
                  "الملف الشخصي",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "معلومات الحساب",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "الاسم: ${name ?? 'غير متوفر'}",
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 7),
              Text(
                "البريد الإلكتروني: ${email ?? 'غير متوفر'}",
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 7),
              if (roll == 4 || roll == 5)
                Text(
                  "الدفعة: $groupName",
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              SizedBox(height: 5),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.2),
              ),
              SizedBox(height: 10),
              if (roll == 5)
                InkWell(
                  onTap: () {
                    if (token != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => JoinClassAgainScreen(token: token!),
                        ),
                      );
                    } else {
                      customSnackBar(
                        context,
                        "لا يمكنك الانضمام لدفعة حاليا",
                        Colors.red,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        "طلب انضمام لدفعة",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),

              if (roll == 4)
                InkWell(
                  onTap: () {
                    if (token != null && groupId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => JoinRequestsScreen(
                                token: token!,
                                groupId: groupId!,
                              ),
                        ),
                      );
                    } else {
                      customSnackBar(
                        context,
                        "لا يمكنك رؤية طلبات الانضمام حاليا",
                        Colors.red,
                      );
                    }
                  },

                  child: Row(
                    children: [
                      Text(
                        "طلبات الانضمام",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              if (roll == 4) SizedBox(height: 15),
              if (roll == 4)
                Row(
                  children: [
                    Text(
                      "الأعضاء",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              SizedBox(height: 10),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.2),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (_) => const ThemeSelectorSheet(),
                  );
                },
                child: Text(
                  "تغيير الوضع",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.mainFontName,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.2),
              ),
              SizedBox(height: 10),
              Text(
                "الشكاوي والمقترحات",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.2),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordRecoveryScreen(),
                    ),
                  );
                },
                child: Text(
                  "تغيير كلمة السر",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.mainFontName,
                  ),
                ),
              ),

              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                    fontFamily: AppFonts.mainFontName,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DropdownButtonFormField(
                        style: TextStyle(
                          fontFamily: AppFonts.mainFontName,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        decoration: InputDecoration(
                          labelText: 'المجموعة',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          errorStyle: TextStyle(
                            fontFamily: AppFonts.mainFontName,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                          hintText: 'المجموعة',
                          hintStyle: Theme.of(context).textTheme.displayMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                     
                   items: [],
                   onChanged: (value) {},
                        
                      ),
              Expanded(child: SizedBox()),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "طور بحب في: ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Image.asset(
                    "assets/images/bitwise.png",
                    width: 100,
                    height: 100,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
