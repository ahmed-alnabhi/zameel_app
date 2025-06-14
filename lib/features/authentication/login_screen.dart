import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/functions/get_device_name.dart';
import 'package:zameel/core/networking/login_service.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/features/authentication/password_recovery/password_recovery_screen.dart';
import 'package:zameel/features/authentication/sign_up_screen.dart';
import 'package:zameel/features/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _Loginfeaturestate();
}

class _Loginfeaturestate extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  Future<void> _login() async {
    String deviceName = await getDeviceName();
    setState(() {
      _isLoading = true;
      _isButtonEnabled = false;
    });
    final loginResult = await loginService(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      deviceName: deviceName,
    );
    setState(() {
      _isLoading = false;
      _isButtonEnabled = true;
    });
    if (loginResult['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', loginResult['token']);
      prefs.setInt('roll', loginResult['roll']);
    

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      if (!mounted) return;
      customSnackBar(
        context,
        loginResult['message'],
        Theme.of(context).colorScheme.error,
      );
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
                        isEnabled: _isLoading ? false : true,
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
                        isEnabled: _isLoading ? false : true,
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
                          isLoading: _isLoading,
                          text: "تسجيل الدخول",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _login();
                            }
                          },
                          isEnabled: _isButtonEnabled,
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
