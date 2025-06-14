import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> createChat({required String? token}) async {
  try {
    final response = await dio.post(
      '$baseUrl/chat/create',
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
      print(data['data']['id']);
      return {
        'success': true,
        'chat_id': data['data']['id'],
        'statusCode': response.statusCode,
      };
    }
    return {
      'success': false,
      'message': 'Failed',
      'statusCode': response.statusCode,
    };
  } on DioException catch (e) {
    if (e.response?.statusCode == 500) {
      return {'success': false, 'message': e, 'statusCode': 500};
    }

    return {
      'success': false,
      'message': e.response?.data['message'],
      'statusCode': e.response?.statusCode,
    };
  } catch (e) {
    print(e);
    return {
      'success': false,
      'message': 'An unexpected error occurred: $e',
      'statusCode': 500,
    };
  }
}
