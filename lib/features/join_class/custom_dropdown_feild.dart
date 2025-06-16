import 'package:flutter/material.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final void Function(String) onSelected;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled
          ? () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => _BottomSheetOptions(
                  title: label,
                  options: options,
                  onSelected: onSelected,
                ),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? label,
              style: TextStyle(
                fontSize: 16,
                color: enabled
                    ? (value == null
                        ? AppColors.textColorDarkModeSecondary
                        : AppColors.primaryColor)
                    : Colors.grey,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: enabled
                  ? (value == null
                      ? AppColors.textColorDarkModeSecondary
                      : AppColors.primaryColor)
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomSheetOptions extends StatelessWidget {
  final String title;
  final List<String> options;
  final void Function(String) onSelected;

  const _BottomSheetOptions({
    required this.title,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...options.map(
                (option) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListTile(
                    title: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppFonts.mainFontName,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    onTap: () {
                      onSelected(option);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
