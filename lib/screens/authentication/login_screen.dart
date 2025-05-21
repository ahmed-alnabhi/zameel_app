import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/screens/authentication/password_recovery/password_recovery_screen.dart';
import 'package:zameel/screens/authentication/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 735),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      SvgPicture.asset(
                        "assets/images/logo.svg",
                        height: 100,
                        width: 200,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 50.h),
                      Text(
                        "أهلا وسهلاً",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        "يمكنك تسجيل الدخول باستخدام حسابك أو قم",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: 10.h),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: Text(
                          "بإنشاء حساب جديد",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      SizedBox(height: 40.h),

                      CustomTextField(
                        hintText: "البريد الإلكتروني",
                        isPassword: false,
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء إدخال البريد الإلكتروني";
                          }
                          if (!value.contains("@")) {
                            return "البريد الإلكتروني غير صالح";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),

                      CustomTextField(
                        hintText: "كلمة المرور",
                        isPassword: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "الرجاء إدخال كلمة المرور";
                          }
                          if (value.length < 6) {
                            return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),

                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: "تسجيل الدخول",
                          onPressed: _submitForm,
                          isEnabled: isButtonEnabled,
                        ),
                      ),
                      SizedBox(height: 30.h),

                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordRecoveryScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "هل نسيت كلمة المرور؟",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
