import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/widget/custom_arrow_back.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/screens/authentication/otp_verification.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _emailController.text.trim().isNotEmpty;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
     
  Navigator.push(context, MaterialPageRoute(builder: (context) =>  OtpVerificationScreen(email: _emailController.text,)));
    
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailController.removeListener(_updateButtonState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.h,) ,
                  customArrowBack(context) ,
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 735),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        children: [
                          SizedBox(height: 100.h),
                          SvgPicture.asset(
                            "assets/images/logo.svg",
                            height: 100,
                            width: 200,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(height: 60.h),
                          Text(
                            "أهلا وسهلاً",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            "قم بادخال بريدك الألكتروني لإستعادة كلمة المرور",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            hintText: "البريد الألكتروني",
                            isPassword: false,
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "البريد الألكتروني مطلوب";
                              }
                              if (!value.contains("@")) {
                                return "البريد الألكتروني غير صحيح";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            text: "استعادة كلمة المرور",
                            onPressed: _submitForm,
                            isEnabled: isButtonEnabled,
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
