import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

final Dio _dio = Dio();

Future<Map<String, dynamic>> fetchAssignmentDelivereis({
  required String? token,
  required int? assignmentID,
  int page = 1,
}) async {
  try {
    final response = await _dio.get(
      '$baseUrl/assignments/$assignmentID/deliveries?page=$page', // ← إضافة رقم الصفحة
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      return {
        'success': true,
        'data': data['data'],
        'meta': data['meta'],
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': 'فشل جلب البيانات',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    return {
      'success': false,
      'message': 'تحقق من اتصالك بالإنترنت',
      'statusCode': e.response?.statusCode ?? 500,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'حدث خطأ غير متوقع',
      'statusCode': 500,
    };
  }
}
