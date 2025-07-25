import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> rejectRequest({
  required String token,
  required int requestId,
}) async {
  try {
    final response = await dio.post(
      '$baseUrl/applies/$requestId/reject',
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
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'statusCode': response.statusCode,
      };
    }
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
