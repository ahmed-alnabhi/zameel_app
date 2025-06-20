import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/networking/profile/fetch_user_info.dart';
import 'package:zameel/core/networking/resources_services/fetch_student_groups.dart';
import 'package:zameel/core/theme/app_fonts.dart';

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
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "طلب انضمام لدفعة",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              if (roll == 4) SizedBox(height: 15),
              if (roll == 4)
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "طلبات الانضمام",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              if (roll == 4) SizedBox(height: 15),
              if (roll == 4)
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "الأعضاء",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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
              Text(
                "تغيير الوضع",
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
              SizedBox(height: 10),
              Text(
                "تغيير كلمة السر",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 10),
              SizedBox(height: 20),
              SizedBox(width: 8),
              TextButton(
                onPressed: () async {},
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
