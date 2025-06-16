import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> verifyResetPasswordOtp({
  required String otp,
  required String email,  
  required String password,
  required String passwordConfirmation,
} ) async {
  try {
    final dio = Dio();

    final response = await dio.post(
      '$baseUrl/reset-password',
      data: {
        'otp': otp , 
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': response.data['message'] ?? 'تم تعيين كلمة المرور بنجاح',
      };
    } else {
      return {
        'success': false,
        'message': 'فشل التحقق(${response.statusCode})',
      };
    }
  } on DioException catch (e) {
    if( e.response?.statusCode == 400){
      return {
      'success': false,
      'message': 'خطأ في رمز التحقق',
    };
    } 
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'خطأ في الاتصال',
    };
  } catch (e) {
    return {'success': false, 'message': 'حدث خطأ غير معروف'};
  }
}
