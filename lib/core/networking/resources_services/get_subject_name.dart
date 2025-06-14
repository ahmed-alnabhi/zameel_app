import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> getSubjectName({
  required String? token,
  required int? subjectId,
}) async {
  try {
    final response = await dio.get(
      '$baseUrl/subjects/$subjectId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      return {
          'success': true,
          'name': data['data']['name'],
          'statusCode': response.statusCode,
        };
     
      } return {
        'success': false,
        'message': 'Failed to fetch data',
        'statusCode': response.statusCode,
      };
    
  } on DioException catch (e) {
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'Connection error',
      'statusCode': e.response?.statusCode ?? 500,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: $e',
      'statusCode': 500,
    };
  }
}