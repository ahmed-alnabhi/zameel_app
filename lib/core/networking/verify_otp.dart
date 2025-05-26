import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> verifyEmail(String token, String otp) async {
  try {
    final dio = Dio();

    final response = await dio.post(
      '$baseUrl/verify-email',
      data: {
        'otp': otp
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': response.data['message'] ?? 'تم التحقق بنجاح  ',
      };
    } else {
      return {
        'success': false,
        'message': 'فشل التحقق(${response.statusCode})',
      };
    }
  } on DioException catch (e) {
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'خطأ في الاتصال',
    };
  } catch (e) {
    return {'success': false, 'message': 'حدث خطأ غير معروف'};
  }
}
