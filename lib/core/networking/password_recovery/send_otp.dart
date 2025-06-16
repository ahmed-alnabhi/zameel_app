import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> sendRecoveryOtp(String email) async {
  try {
    final dio = Dio();

    final response = await dio.post(
      '$baseUrl/forgot-password', 
       data: {'email': email,},
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
        'message': response.data['message'] ?? 'تم إرسال رمز التحقق بنجاح',
      };
    } else {
      return {
        'success': false,
        'message': 'فشل في إرسال رمز التحقق (${response.statusCode})',
      };
    }
  } on DioException catch (e) {
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'خطأ في الاتصال',

    };
  } catch (e) {
    return {
      'success': false,
      'message': 'حدث خطأ غير معروف',
    };
  }
}
