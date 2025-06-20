import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:zameel/core/functions/get_color_by_ext.dart';
import 'package:zameel/core/networking/resources_services/fetch_all_books.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:zameel/core/networking/resources_services/upload_books_service.dart';
import 'package:zameel/core/theme/app_fonts.dart';

class SubjectBooksScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final int semester;
  final int groupId;

  const SubjectBooksScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
    required this.groupId,
    required this.semester,
  });

  @override
  State<SubjectBooksScreen> createState() => _SubjectBooksScreenState();
}

class _SubjectBooksScreenState extends State<SubjectBooksScreen> {
  bool isLoading = true;
  List books = [];
  String? fileExt;
  int? roll;

  Future<void> getRoll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    roll = prefs.getInt('roll');
  }

  String getFileExtension(String filePath) {
    // Split the string by '/' and take the last part (the file name)
    String fileName = filePath.split('/').last;

    // Split the file name by '.' and take the last part (the extension)
    if (fileName.contains('.')) {
      return fileName.split('.').last.toUpperCase();
    } else {
      return ''; // Return empty string if there's no extension
    }
  }

  Future<void> _fetchSubjectBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final groupId = prefs.getInt('selectedGroupId');

    final result = await fetchAllBooks(token: token, groupId: groupId);
    if (result['success']) {
      final response = result['data'] as Response;
      final allBooks = response.data['data'] as List;

      books =
          allBooks
              .where((book) => book['subject_id'] == widget.subjectId)
              .toList();

      setState(() => isLoading = false);
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    _fetchSubjectBooks();
    getRoll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          toolbarHeight: 60,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Column(
            children: [
              SvgPicture.asset("assets/images/logo.svg", height: 55, width: 88),
              SizedBox(height: 6),

              //      SizedBox(height: 5),
            ],
          ),
        ),

        //   AppBar(
        //     title: Text(" المواد > ${widget.subjectName}  >" , style:
        //  TextStyle(
        //     fontFamily: AppFonts.mainFontName ,
        //     fontSize: 14 ,
        //     fontWeight:  FontWeight.w400,
        //  ) ),

        //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   ),
        body:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : books.isEmpty
                ? Center(child: Text('لا توجد كتب لهذه المادة'))
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // يرجع إلى شاشة المواد
                            },
                            child: Text(
                              "المواد",
                              style: TextStyle(
                                fontFamily: AppFonts.mainFontName,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          const Text(" > ", style: TextStyle(fontSize: 16)),
                          Text(
                            widget.subjectName,
                            style: TextStyle(
                              fontFamily: AppFonts.mainFontName,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSecondaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: Row(
                                    children: [
                                      // مربع نوع الملف
                                      Container(
                                        decoration: BoxDecoration(
                                          color: getColorByExtension(
                                            getFileExtension(
                                              books[index]['path'],
                                            ),
                                          ).withValues(alpha: 0.2),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                        width: 60,
                                        height: 60,
                                        child: Center(
                                          child: Text(
                                            getFileExtension(
                                              books[index]['path'],
                                            ),
                                            style: TextStyle(
                                              color: getColorByExtension(
                                                getFileExtension(
                                                  books[index]['path'],
                                                ),
                                              ),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // اسم الملف
                                      Expanded(
                                        child: Text(
                                          books[index]['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      // زر التحميل
                                      IconButton(
                                        icon: Icon(
                                          LucideIcons.download,
                                          color:
                                              Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey
                                                  : Colors.black,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          print(books[index]['id']);
                                        },
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        floatingActionButton:
            (roll == 1 || roll == 2 || roll == 3 || roll == 4)
                ? FloatingActionButton(
                  heroTag: "publishBooks",
                  onPressed: () {
                    _showUploadDialog(
                      semester: widget.semester,
                      subjectId: widget.subjectId,
                      groupId: widget.groupId,
                    );
                  },
                  child: Icon(LucideIcons.upload, color: Colors.white),
                )
                : null,
      ),
    );
  }

  void _showUploadDialog({
    required int subjectId,
    required int semester,
    required int groupId,
  }) async {
    String bookName = "";
    bool isArabic = false;
    bool isPractical = false;
    File? selectedFile;
    bool isUpLoading = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: Text(
                    'رفع ملزمة جديدة',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppFonts.mainFontName,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (value) => bookName = value,
                          decoration: InputDecoration(
                            labelText: 'اسم الملزمة',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontFamily: AppFonts.mainFontName,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: isArabic,
                              side: BorderSide(color: Colors.grey),
                              onChanged:
                                  (value) => setState(() => isArabic = value!),
                            ),
                            Text(
                              'الملزمة باللغة العربية',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.mainFontName,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: isPractical,
                              side: BorderSide(color: Colors.grey),
                              onChanged:
                                  (value) =>
                                      setState(() => isPractical = value!),
                            ),
                            Text(
                              'الملزمة عملي',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.mainFontName,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result =
                                await FilePicker.platform.pickFiles();
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
                                ? 'اختر ملف'
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
                                setState(() {
                                  isUpLoading = true;
                                });
                                if (bookName.isEmpty || selectedFile == null) {
                                  setState(() {
                                    isUpLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      content: Text(
                                        'يرجى إدخال الاسم واختيار الملف',
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

                                final prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token')!;

                                await uploadBook(
                                  token: token,
                                  bookName: bookName,
                                  file: selectedFile!,
                                  subjectId: widget.subjectId.toString(),
                                  isPractical: isPractical ? 1 : 0,
                                  isArabic: isArabic ? 1 : 0,
                                  year: 1,
                                  semester: semester,
                                  groupId: groupId,
                                );
                                setState(() {
                                  isUpLoading = false;
                                });
                                Navigator.pop(context);
                              
                                _fetchSubjectBooks(); // تحديث قائمة الكتب بعد الرفع
                              },
                              child: Text(
                                isUpLoading ? 'جاري الرفع' : 'رفع',
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
              ),
        );
      },
    );
  }
}
