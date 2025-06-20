import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zameel/core/functions/days_left_or_date.dart';
import 'package:zameel/core/functions/format_time_ago.dart';
import 'package:zameel/core/networking/assignments/upload_delivery_file.dart';
import 'package:zameel/core/theme/app_colors.dart';
import 'package:zameel/core/theme/app_fonts.dart';
import 'package:zameel/core/widget/custom_button.dart';
import 'package:zameel/core/widget/custom_snack_bar.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> assignment;
  const AssignmentDetailsScreen({super.key, required this.assignment});

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            Theme.of(context).brightness == Brightness.light
                ? AppColors.primaryLightColor
                : Theme.of(context).colorScheme.onSecondaryContainer,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          elevation: 0,
          title: Text(
            "تفاصيل التكليف",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: AppFonts.mainFontName,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                "عنوان التكليف:",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${widget.assignment['title']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "وصف التكليف:",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${widget.assignment['description']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.7,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "مادة التكليف:",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${widget.assignment['subject_id']}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Text(
                "تاريخ الإنشاء:",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                formatTimeAgo(widget.assignment['created_at']),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              Text(
                "اخر موعد للتسليم:",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                daysLeftOrDate(widget.assignment['due_date']),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              CustomButton(
                text: "تسليم التكليف",
                onPressed: () {
                  _showUploadDialog(assignmentId: widget.assignment['id']);
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadDialog({required int assignmentId}) async {
    File? selectedFile;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                title: Text(
                  'رفع واجب',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.mainFontName,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles();
                          if (result != null &&
                              result.files.single.path != null) {
                            setState(() {
                              selectedFile = File(result.files.single.path!);
                            });
                          }
                        },
                        icon: Icon(LucideIcons.paperclip),
                        label: Text(
                          selectedFile == null
                              ? 'اختر ملف PDF'
                              : 'تم اختيار الملف',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppFonts.mainFontName,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: AppFonts.mainFontName,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (selectedFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    content: Text(
                                      'يرجى اختيار ملف أولاً',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: AppFonts.mainFontName,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                isUploading = true;
                              });

                              final prefs =
                                  await SharedPreferences.getInstance();
                              final token = prefs.getString('token');

                              if (token == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('لم يتم العثور على التوكن'),
                                  ),
                                );
                                setState(() => isUploading = false);
                                return;
                              }

                              final result = await uploadAssignmentFile(
                                file: selectedFile!,
                                token: token,
                                assignmentId: assignmentId,
                              );
                              if (result['success']) {
                                customSnackBar(
                                  context,
                                  result['message'],
                                  Colors.green,
                                );
                                  Navigator.pop(context);
                              } else {
                                customSnackBar(
                                  context,
                                  result['message'],
                                  Colors.red,
                                );
                                 Navigator.pop(context);
                              }

                              setState(() {
                                isUploading = false;
                              });

                            
                            },
                            child: Text(
                              isUploading ? 'جاري الرفع...' : 'رفع',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: AppFonts.mainFontName,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
