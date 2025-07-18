import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:zameel/core/functions/get_device_name.dart';
import 'package:zameel/core/networking/register.dart';
import 'package:zameel/core/networking/send_otp.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/widget/custom_arrow_back.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/features/authentication/otp_verification.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isChecked = false;
  bool isDisabled = false;
  bool isLoading = false;
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
    _nameController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          _emailController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _nameController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty &&
          isChecked == true;
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
    _confirmPasswordController.removeListener(_updateButtonState);
    _nameController.removeListener(_updateButtonState);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
     String deviceName = await getDeviceName();
    setState(() {
      isDisabled = true;
      isLoading = true;
    });
    

    final result = await registerUser(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
      deviceName: deviceName,
    );
    if (result['success']) {
      String accessToken = result['token'];
      final resultEmailRequest = await sendEmailNotification(accessToken);
      if (resultEmailRequest['success']) {
        if (!mounted) return;
        setState(() {
          isDisabled = false;
          isLoading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => OtpVerificationScreen(
                  email: _emailController.text.trim(),
                  token: accessToken,
                ),
          ),
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        isDisabled = false;
        isLoading = false;
      });
       
       customSnackBar(context,result['message'], Theme.of(context).colorScheme.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  customArrowBack(context),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 735),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          SvgPicture.asset(
                            "assets/images/logo.svg",
                            height: 100,
                            width: 200,
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            "انشاء حساب جديد",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(
                                "لديك حساب مسبقاً؟ قم ",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "بتسجيل الدخول ",
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            isEnabled: isLoading ? false : true,
                            hintText: "الاسم الرباعي",
                            isPassword: false,
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "يرجى إدخال الاسم الرباعي";
                              }
                              final words =
                                  value
                                      .trim()
                                      .split(RegExp(r'\s+'))
                                      .where((word) => word.isNotEmpty)
                                      .toList();

                              if (words.length != 4 ) {
                                return 'يرجى إدخال اسم رباعي صحيح';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            isEnabled: isLoading ? false : true,
                            hintText: "البريد الالكتروني",
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
                          SizedBox(height: 16.h),
                          CustomTextField(
                            isEnabled: isLoading ? false : true,
                            hintText: "كلمة المرور",
                            isPassword: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "الرجاء إدخال كلمة المرور";
                              }
                              if (value.length < 8) {
                                return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return "كلمة المرور يجب أن تحتوي على رقم واحد على الأقل";
                              }
                              if (!RegExp(
                                r'[!@#$%^&*(),.?":{}|<>]',
                              ).hasMatch(value)) {
                                return "كلمة المرور يجب أن تحتوي على رمز واحد على الأقل";
                              }
                              if (!RegExp(
                                r'(?=.*[a-z])(?=.*[A-Z])',
                              ).hasMatch(value)) {
                                return "كلمة المرور يجب أن تحتوي على حرف صغير وحرف كبير على الأقل";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          CustomTextField(
                            isEnabled: isLoading ? false : true,
                            hintText: "تأكيد كلمة المرور",
                            isPassword: true,
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "الرجاء إدخال تأكيد كلمة المرور";
                              }
                              if (value != _passwordController.text) {
                                return "كلمة المرور غير متطابقة";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MSHCheckbox(
                                size: 20,
                                value: isChecked,
                                duration: const Duration(milliseconds: 400),
                                colorConfig:
                                    MSHColorConfig.fromCheckedUncheckedDisabled(
                                      checkedColor: AppColors.primaryColor,
                                    ),
                                style: MSHCheckboxStyle.stroke,
                                onChanged: (selected) {
                                  setState(() {
                                    isChecked = selected;
                                    _updateButtonState();
                                  });
                                },
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    children: [
                                      const TextSpan(
                                        text:
                                            'من خلال إنشاء حساب، فإنك توافق على ',
                                      ),
                                      TextSpan(
                                        text: 'الشروط والأحكام الخاصة بنا',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryColor,
                                          decoration: TextDecoration.underline,
                                          decorationColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            isLoading: isLoading,
                            text: "انشاء حساب",
                            isEnabled: isLoading ? false : isButtonEnabled,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _handleRegister();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
