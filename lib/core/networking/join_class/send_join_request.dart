import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> sendJoinRequest({
  required String token,
  required int groupId,
}) async {
  try {
    final response = await dio.post(
      '$baseUrl/groups/$groupId/applies',
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
        'data': data['data'],
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to fetch data',
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
