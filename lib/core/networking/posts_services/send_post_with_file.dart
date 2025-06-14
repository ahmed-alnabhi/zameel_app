import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> sendPostWithFile({
  required String token,
  required int taggableId,
  required File file,
  required String content,
}) async {
  final dio = Dio();

  final Map<String, dynamic> formDataMap = {
    'taggable_id': taggableId.toString(),
    'taggable_type': 'App\\Models\\Group',
    'content': content,
    'attachment[type]': "file",
    'attachment[file]': await MultipartFile.fromFile(
      file.path,
      filename: basename(file.path),
    ),
  };

  final formData = FormData.fromMap(formDataMap);

  try {
    final response = await dio.post(
      '$baseUrl/posts',
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          // قد تحتاج هنا لتحديد Content-Type ولكن Dio يتعامل مع FormData تلقائياً
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': response.data['message'] ?? 'تم ارسال المنشور بنجاح',
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': 'فشل في إرسال المنشور (${response.statusCode})',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    print(e); 
    if (e.response?.statusCode == 422) {
      return {
        'success': false,
        'message': e.response?.data,
        'statusCode': e.response?.statusCode ?? 401,
      };
    }

    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'خطأ في الاتصال: ${e.message}',
      'statusCode': e.response?.statusCode ?? 500,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'حدث خطأ غير معروف: $e',
      'statusCode': 500,
    };
  }
}
