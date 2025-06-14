import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:zameel/core/networking/constant.dart';

Future<void> uploadBook({
  required String token, 
  required String bookName, 
  required File file,
  required String subjectId, 
  required int isPractical, 
  required int year, 
  required int semester, 
  required int isArabic, 
  required int groupId,
}) async {
  final dio = Dio();


  // ملف الكتاب

  // البيانات المرفقة مع الطلب
  final formData = FormData.fromMap({
    'name': bookName,
    'path': await MultipartFile.fromFile(
      file.path,
      filename: basename(file.path),
    ),
    'subject_id': subjectId,
    'is_practical': isPractical,
    'year': year,
    'semester': semester,
    'is_arabic': isArabic,
    'group_id': groupId,
  });

  try {
    final response = await dio.post(
      "$baseUrl/books",
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 201) {
      print('تم رفع الكتاب بنجاح');
    } else {
      print('فشل في الرفع: ${response.statusCode}');
    }
  } catch (e) {
    print('حدث خطأ: $e');
  }
}
