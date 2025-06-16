import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64.h,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled
                  ? AppColors.primaryColor
                  : AppColors.primaryColor.withValues(alpha: 0.7),  
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        child: isLoading?  LoadingIndicator(
              indicatorType: Indicator.circleStrokeSpin,
              colors: const [Colors.white],
              strokeWidth: 3,
              
            ) : Text(
          text,
          style: TextStyle(
            color: isEnabled? AppColors.textButtonColor :AppColors.textButtonColor.withValues(alpha: 0.7),
            fontSize: 16,
            fontFamily: AppFonts.mainFontName,
            fontWeight: FontWeight.w500,
          ),
        )
      ),
    );
  }
}