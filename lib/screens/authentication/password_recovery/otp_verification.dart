import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_arrow_back.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zameel/screens/authentication/password_recovery/reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  bool isButtonEnabled = false;
  final TextEditingController _otpController = TextEditingController();
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
                                Theme.of(context).colorScheme.onTertiaryContainer,
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
                          constraints:  BoxConstraints(maxWidth: 400),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 4,
                              obscureText: false,
                              controller: _otpController,
                              animationType: AnimationType.scale,
                              animationCurve: Curves.linear,
                              animationDuration: const Duration(milliseconds: 200),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              cursorColor: Theme.of(context).colorScheme.onPrimary,
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                                fieldHeight: 64,
                                fieldWidth: 64,
                                activeColor:
                                    AppColors
                                        .primaryColor, // border color when selected
                                selectedColor: AppColors.primaryColor,
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
                            if (_otpController.text.length == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                   ResetPasswordScreen()
                                ),
                              );
                            } 
                          },
                          isEnabled: true,
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          height: 64.h,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
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
                              "إعادة إرسال الكود",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSecondary ,
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
