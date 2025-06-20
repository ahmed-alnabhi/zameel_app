import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> uploadAssignmentFile({
  required File file,
  required String token,
  required int assignmentId,
}) async {
  final dio = Dio();

  try {
   

    FormData formData = FormData.fromMap({
      'type': 'file',
      'content': await MultipartFile.fromFile(file.path, filename: basename(file.path)),
    });

    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.post(
      "$baseUrl/assignments/$assignmentId/deliveries",
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': 'تم رفع الملف بنجاح',
        'data': response.data,
      };
    } else {
      return {
        'success': false,
        'message': 'فشل رفع الملف',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    if (e.response!.statusCode == 409){
      return {
        'success': false,
        'message': 'تم رفع الملف مسبقاً',
        'statusCode': e.response!.statusCode,
      };
    }
    return {
      'success': false,
      'message': 'حدث خطأ غير : $e',
      'statusCode': e.response!.statusCode,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'حدث خطأ غير متوقع: $e',
      'statusCode': 500,
    };
  }
}
