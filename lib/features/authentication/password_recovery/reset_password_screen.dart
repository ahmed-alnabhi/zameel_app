import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/widget/custom_arrow_back.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';
import 'package:zameel/features/authentication/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordfeaturestate();
}

class _ResetPasswordfeaturestate extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          _passwordController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _passwordController.clear();
      _confirmPasswordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordController.removeListener(_updateButtonState);
    _passwordController.removeListener(_updateButtonState);
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
                  SizedBox(height: 30.h),
                  customArrowBack(context),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 735),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Column(
                        children: [
                          SizedBox(height: 90.h),
                    
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.r),
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onTertiaryContainer,
                            ),
                            width: 100,
                            height: 100,
                            child: Image.asset(
                              "assets/images/lock.png",
                              width: 70.w,
                              height: 70.h,
                            ),
                          ),
                          SizedBox(height: 60.h),
                          Text(
                            "استعادة كلمة المرور",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "قم بانشاء كلمة مرور جديدة",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          SizedBox(height: 20.h),
                          CustomTextField(
                            hintText: "كلمة المرور الجديدة",
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
                          SizedBox(height: 10.h),
                          CustomTextField(
                            hintText: "تأكيد كلمة المرور الجديدة",
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
                    
                          SizedBox(height: 24.h),
                          CustomButton(
                            text: "اعادة تعيين كلمة المرور",
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
