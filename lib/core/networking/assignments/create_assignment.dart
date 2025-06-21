import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';




Future<Map<String, dynamic>> createAssignmentService({
  required String? token,
  required String? title,
  required String? description,
  required String? dueDate,
  required int? groupId , 
  required int? subjectId,
}) async {
  final Dio dio = Dio();
  try {
    final response = await dio.post(
      '$baseUrl/assignments',
      data: {
        'title': title,
        'description': description,
        'due_date': dueDate,
        'group_id': groupId,
        'subject_id': subjectId,
      } , 
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    
      return {
        'success': true,
        'data': "تم النشر بنجاح",
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': 'فشل النشر',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    return {
      'success': false,
      'message': 'تحقق من اتصالك بالانترنت',
      'statusCode': e.response?.statusCode ?? "500",
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'حدث خطأ غير متوقع',
      'statusCode': 500,
    };
  }
}

