import 'package:flutter/material.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/features/join_class/custom_dropdown_feild.dart';
import 'package:zameel/main.dart'; // فيه themeNotifier

class ThemeSelectorSheet extends StatefulWidget {
  const ThemeSelectorSheet({super.key});

  @override
  State<ThemeSelectorSheet> createState() => _ThemeSelectorSheetState();
}

class _ThemeSelectorSheetState extends State<ThemeSelectorSheet> {
  String? selectedValue;

  final List<String> themeOptions = ['ليلي', 'نهاري', 'افتراضي'];

  void _applyTheme() {
    switch (selectedValue) {
      case 'ليلي':
        themeNotifier.value = ThemeMode.dark;
        break;
      case 'نهاري':
        themeNotifier.value = ThemeMode.light;
        break;
      case 'افتراضي':
        themeNotifier.value = ThemeMode.system;
        break;
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تغيير الوضع بنجاح', style: TextStyle(fontSize: 12), )),
    );
  }

  @override
  void initState() {
    super.initState();

    // تعيين القيمة الافتراضية حسب الثيم الحالي
    final current = themeNotifier.value;
    selectedValue = current == ThemeMode.dark
        ? 'ليلي'
        : current == ThemeMode.light
            ? 'نهاري'
            : 'افتراضي';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration:  BoxDecoration(
        color:Theme.of(context).brightness == Brightness.dark? Colors.black26 : Color(0xffE3E9F4),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'حدد الوضع',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          CustomDropdownField(
            label: 'اختر الوضع',
            value: selectedValue,
            options: themeOptions,
            onSelected: (val) {
              setState(() {
                selectedValue = val;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _applyTheme,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C6AC4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('اختيار' , style: TextStyle( color: Colors.white,fontSize: 16, fontFamily: AppFonts.mainFontName)),
          )
        ],
      ),
    );
  }
}
