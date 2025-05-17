import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  // Color? backgroundColor;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true, // ✅ قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppColors.primaryColor
              : AppColors.primary50opacityColor,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: AppFonts.mainFontName,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
