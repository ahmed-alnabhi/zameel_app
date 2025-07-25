import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';



final Dio _dio = Dio();
Future<Map<String, dynamic>> fetchAssignmentsService({
  required String? token,
  required String? cursor,
  bool? before,
}) async {
  
  try {
    final response = await _dio.get(
      '$baseUrl/assignments',
      queryParameters: {'cursor': cursor, 'before': before},
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      return {
        'success': true,
        'data': data['data'],
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

