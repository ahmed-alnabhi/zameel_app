import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';
Dio dio = Dio();

Future<Map<String, dynamic>> registerUser({
  required String name,
  required String email,
  required String password,
  required String confirmPassword,
  required String deviceName,
}) async {
  try {
    final response = await dio.post(
      '$baseUrl/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': confirmPassword,
        'deviceName': deviceName, 
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;
      
      // print(data);
      return {
        'success': true,
        'token': data['data']['token'],
        'statusCode': response.statusCode,
      };
    } 
    else {
      return {
        'success': false,
        'message': 'حدث خطأ غير متوقع',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    if(e.response?.statusCode == 409){
      return {
        'success': false,
        'message': 'الحساب مسجل مسيقا',
        'statusCode': e.response?.statusCode?? '409',
      };
    } else{
      
    } return {
      'success': false,
      'message': e.response?.data['title'] ?? 'خطأ في الاتصال',
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
