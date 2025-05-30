import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool isEnabled;
  final bool hasPrefix;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    this.validator,
    this.isEnabled = true,
    this.hasPrefix = false,
    this.prefixIcon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      cursorColor: AppColors.primaryColor,
      controller: widget.controller,
      obscureText: widget.isPassword && !showPassword,
      validator: widget.validator,
      style: TextStyle(
        fontFamily: AppFonts.mainFontName,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 19),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        errorStyle: TextStyle(
          fontFamily: AppFonts.mainFontName,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Theme.of(context).colorScheme.error,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.onSecondaryContainer,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.displayMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        prefixIcon: widget.hasPrefix? Icon(
          widget.prefixIcon,
          color: Theme.of(context).colorScheme.onTertiary,
          size: 24,
        ) : null ,

        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon:
                      showPassword
                          ? Icon(
                            LucideIcons.eye,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          )
                          : Icon(
                            LucideIcons.eyeOff,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                )
                : null,
      ),
    );
  }
}
