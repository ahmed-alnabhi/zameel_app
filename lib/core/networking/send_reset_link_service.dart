import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<Map<String, dynamic>> senResetLink(String email) async {
  try {
    final dio = Dio();

    final response = await dio.post(
      '$baseUrl/forgot-password',
      data: {'email': email},
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
        'message': response.data['message'] ?? 'تم إرسال الرابط بنجاح',
      };
    } else {
      return {
        'success': false,
        'message': 'فشل في إرسال الرابط (${response.statusCode})',
      };
    }
  }  catch (e) {
    return {'success': false, 'message': 'حدث خطأ في الاتصال، يرجى التحقق من الاتصال بالإنترنت.'};
  }
}
