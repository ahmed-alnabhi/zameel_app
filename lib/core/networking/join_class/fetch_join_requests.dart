import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> fetchJoinRequests({
  required String token,
  required int groupId,
  int page = 1,
}) async {
  try {
    final response = await dio.get(
      '$baseUrl/groups/$groupId/applies',
      queryParameters: {
        'page': page,
      },
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
        'links': data['links'],
        'meta': data['meta'],
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
