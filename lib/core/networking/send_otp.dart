import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> sendEmailNotification(String token) async {
  try {
    final dio = Dio();

    final response = await dio.post(
      '$baseUrl/email/verification-notification', 
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': response.data['message'] ?? 'تم إرسال الإشعار بنجاح',
      };
    } else {
      return {
        'success': false,
        'message': 'فشل في إرسال الإشعار (${response.statusCode})',
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
