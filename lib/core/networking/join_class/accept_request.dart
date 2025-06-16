import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> acceptRequest({
  required String token,
  required int requestId,
}) async {
  try {
    final response = await dio.post(
      '$baseUrl/applies/$requestId/accept',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'statusCode': response.statusCode};
    } else {
      return {'success': false, 'statusCode': response.statusCode};
    }
  } on DioException catch (e) {
    print(e);
    print(token);
    print(requestId);
    if (e.response?.statusCode == 500) {
      print(e.response?.data);
      return {
        'success': false,
        'message': e,
        'statusCode': e.response?.statusCode,
      };
    }
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'Connection error      $e',
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
