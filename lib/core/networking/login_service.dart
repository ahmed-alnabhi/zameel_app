import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> loginService({
  required String email,
  required String password,
  required String deviceName,
}) async {
  try {
    final response = await dio.post(
      '$baseUrl/login',
      data: {'email': email, 'password': password, 'deviceName': deviceName},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;

      return {
        'success': true,
        'name': data['data']['name'],
        'email': data['data']['email'],
        'token': data['data']['token'],
        'roll': data['data']['role_id'],
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      return {
        'success': false,
        'verified': 'false',
        'message': 'خطأ في البريد أو الرمز السري',
        'statusCode': e.response?.statusCode?? 401,
      };
    }
    
    return {
      'success': false,
      'message': e.response?.data['mesage'] ?? 'خطأ في الاتصال',
      'statusCode': e.response?.statusCode ?? 500,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'تعذر الاتصال بالخادم، تحقق من الاتصال بالانترنت',
      'statusCode': 500,
    };
  }
}
