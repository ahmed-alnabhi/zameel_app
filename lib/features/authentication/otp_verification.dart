import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/networking/send_otp.dart';
import 'package:zameel/core/networking/verify_otp.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_arrow_back.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/features/authentication/login_screen.dart';
import 'package:zameel/features/home/home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String token;
  final String email;
  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationfeaturestate();
}

class _OtpVerificationfeaturestate extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResendLoading = false;
  bool _isvalid = false;
  bool _isUnvalid = false;
  bool _isButtonEnabled = false;
  int _secondsRemaining = 60;
  bool _isSecondButtonenabled = false;
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
          _isSecondButtonenabled = true;
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
    if (_otpController.text.length == 4) {
      setState(() {
        _isLoading = true;
        _isButtonEnabled = false;
      });
      final resultOfVerifyEmail = await verifyEmail(
        widget.token,
        _otpController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (resultOfVerifyEmail['success']) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token',widget.token);
        setState(() {
          _isvalid = true;
          _isUnvalid = false;
        });
        if (!mounted) return;
        Future.delayed(const Duration(milliseconds: 400), () {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        });
      } else {
        if (!mounted) return;
        setState(() {
          _isvalid = false;
          _isUnvalid = true;
        });
        customSnackBar(
          context,
          resultOfVerifyEmail['message'],
          Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  Future<void> resendOtp() async {
    setState(() {
      _isResendLoading = true;
    });

    final resultOfResendOtp = await sendEmailNotification(widget.token);

    setState(() {
      _isResendLoading = false;
    });

    if (resultOfResendOtp['success']) {
      setState(() {
        _secondsRemaining = 60;
        _isSecondButtonenabled = false;
      });
      _startTimer();
      if (!mounted) return;
      customSnackBar(context, "تم الارسال بنجاح", Colors.green);
    } else {
      if (!mounted) return;
      customSnackBar(
        context,
        resultOfResendOtp['message'],
        Theme.of(context).colorScheme.error,
      );
    }
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
                              enabled: !_isLoading,
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
                                disabledColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSecondaryContainer,
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                                fieldHeight: 64,
                                fieldWidth: 64,
                                activeColor:
                                    _isvalid
                                        ? Colors.green
                                        : _isUnvalid
                                        ? Colors.red
                                        : AppColors.primaryColor,
                                selectedColor:
                                    _isvalid
                                        ? Colors.green
                                        : _isUnvalid
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
                          isLoading: _isLoading,
                          text: "التالي",
                          onPressed: _isButtonEnabled ? null : verifyOtp,
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          height: 64.h,
                          child: ElevatedButton(
                            onPressed:
                                _isSecondButtonenabled ? resendOtp : null,
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
                            child:
                                _isResendLoading
                                    ? LoadingIndicator(
                                      indicatorType: Indicator.ballPulse,
                                      colors: const [Colors.white],
                                      strokeWidth: 2,
                                    )
                                    : Text(
                                      _isSecondButtonenabled
                                          ? 'إعادة الإرسال'
                                          : 'إعادة الإرسال بعد $_secondsRemaining ث',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSecondary,
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
