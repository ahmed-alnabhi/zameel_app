import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/networking/send_otp.dart';
import 'package:zameel/core/networking/verify_otp.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_arrow_back.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zameel/screens/authentication/login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String token;
  final String email;
  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String otp = '0000';
  bool isvalid = false;
  bool isUnvalid = false;
  bool isButtonEnabled = false;
  int _secondsRemaining = 120;
  bool _isSecondButtonDisabled = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _isSecondButtonDisabled = false;
          _timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  Future<void> verifyOtp() async {
    showDialog(
      requestFocus: true,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      },
    );
    final resultOfVerifyEmail = await verifyEmail(
      widget.token,
      _otpController.text.trim(),
    );
    if (resultOfVerifyEmail['success']) {
      setState(() {
        isvalid = true;
        isUnvalid = false;
      });
      if (!mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        isvalid = false;
        isUnvalid = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP', style: TextStyle(fontSize: 14)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> resendOtp() async {
    setState(() {
      _secondsRemaining = 120;
      _isSecondButtonDisabled = true;
    });
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      },
    );
    final resultOfResendOtp = await sendEmailNotification(widget.token);
    if (resultOfResendOtp['success']) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم الارسال مجدداً بنجاح',
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ ما', style: TextStyle(fontSize: 12)),
          backgroundColor: Colors.red,
        ),
      );
    }

    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30.h),
                customArrowBack(context),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 735),
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
                        SizedBox(height: 40.h),
                        Text(
                          "قم بتأكيد هويتك",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          "لقد قمنا بارسال كود التحقق الى",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          widget.email,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: 40.h),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 400),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              obscureText: false,
                              controller: _otpController,
                              animationType: AnimationType.scale,
                              animationCurve: Curves.linear,
                              animationDuration: const Duration(
                                milliseconds: 200,
                              ),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              cursorColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                                fieldHeight: 64,
                                fieldWidth: 64,
                                activeColor:
                                    isvalid
                                        ? Colors.green
                                        : isUnvalid
                                        ? Colors.red
                                        : AppColors.primaryColor,
                                // border color when selected
                                selectedColor:
                                    isvalid
                                        ? Colors.green
                                        : isUnvalid
                                        ? Colors.red
                                        : AppColors.primaryColor,
                                inactiveColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                activeFillColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                selectedFillColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                inactiveFillColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                errorBorderColor: Colors.red,
                              ),
                              onChanged: (value) {},

                              beforeTextPaste: (text) => true,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        CustomButton(
                          text: "التالي",
                          onPressed: () {
                            verifyOtp();
                          },
                          isEnabled: true,
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          height: 64.h,
                          child: ElevatedButton(
                            onPressed:
                                _isSecondButtonDisabled ? null : resendOtp,
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                              backgroundColor:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              _isSecondButtonDisabled
                                  ? 'اعادة الارسال بعد $_secondsRemaining ث'
                                  : 'إعادة الارسال',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: 16,
                                fontFamily: AppFonts.mainFontName,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
    );
  }
}
