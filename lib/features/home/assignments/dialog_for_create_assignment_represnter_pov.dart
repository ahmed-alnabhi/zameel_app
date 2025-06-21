import 'package:flutter/material.dart';
import 'package:zameel/core/networking/assignments/create_assignment.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';
import 'package:zameel/core/widget/custom_text_feild.dart';

void showDialogForCreateAssignmentRepresnterPov({
  required BuildContext context,
  required List<Map<String, dynamic>> groups,
  required String token,
}) {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();

  String? selectedGroupName;
  int? selectedGroupId;
  String? selectedSubjectName;
  int? selectedSubjectId;
  bool isLoading = false;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void onGroupChanged(String? newGroupName) {
            if (newGroupName == null) return;

            setState(() {
              selectedGroupName = newGroupName;
              final group = groups.firstWhere(
                (g) => g['group_name'] == newGroupName,
              );
              selectedGroupId = group['group_id'];
              selectedSubjectName = group['subject_name'];
              selectedSubjectId = group['subject_id'];
            });
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(
                'إضافة تكليف جديد',
                style: TextStyle(
                  fontFamily: AppFonts.mainFontName,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        hintText: "العنوان",
                        isPassword: false,
                        controller: titleController,
                        contentHeight: 12,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'العنوان مطلوب'
                                    : null,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: "الوصف",
                        isPassword: false,
                        controller: descriptionController,
                        contentHeight: 12,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'الوصف مطلوب'
                                    : null,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: "تاريخ السليم",
                        isPassword: false,
                        controller: dueDateController,
                        contentHeight: 12,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary:
                                        AppColors.primaryColor, // لون التحديد
                                    onPrimary:
                                        Colors
                                            .white, // لون النص في الزر المختار
                                    onSurface: Colors.black, // لون النص العادي
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (date != null) {
                            dueDateController.text =
                                date.toIso8601String().split('T').first;
                          }
                        },

                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'تاريخ التسليم مطلوب'
                                    : null,
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        style: TextStyle(
                          fontFamily: AppFonts.mainFontName,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          errorStyle: TextStyle(
                            fontFamily: AppFonts.mainFontName,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                          hintText: 'المجموعة',
                          hintStyle: TextStyle(
                            fontFamily: AppFonts.mainFontName,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: selectedGroupName,
                        items:
                            groups
                                .map(
                                  (group) => DropdownMenuItem<String>(
                                    value: group['group_name'],
                                    child: Text(group['group_name']),
                                  ),
                                )
                                .toList(),
                        onChanged: onGroupChanged,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'المجموعة مطلوبة'
                                    : null,
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        hintText: 'اسم المادة',
                        isPassword: false,
                        contentHeight: 12,
                        controller: TextEditingController(
                          text: selectedSubjectName ?? '',
                        ),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: AppFonts.mainFontName,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () => isLoading = true,
                              ); // ✅ بداية التحميل

                              final result = await createAssignmentService(
                                token: token,
                                title: titleController.text,
                                description: descriptionController.text,
                                dueDate: dueDateController.text,
                                groupId: selectedGroupId,
                                subjectId: selectedSubjectId,
                              );

                              setState(
                                () => isLoading = false,
                              ); // ✅ نهاية التحميل

                              if (result['success']) {
                                customSnackBar(
                                  context,
                                  result['message'] ?? "تم النشر بنجاح",
                                  Colors.green,
                                );
                                Navigator.of(context).pop();
                              } else {
                                customSnackBar(
                                  context,
                                  result['message'] ?? "حدث خطأ غير متوقع",
                                  Colors.red,
                                );
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child:
                      isLoading
                          ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                          : Text(
                            'إنشاء',
                            style: TextStyle(
                              fontFamily: AppFonts.mainFontName,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
