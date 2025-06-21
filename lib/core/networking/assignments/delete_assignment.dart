import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';




Future<Map<String, dynamic>> deleteAssignmentService({
  required String? token,
  required int? assignmentID,

}) async {
  final Dio dio = Dio();
  try {
    final response = await dio.delete(
      '$baseUrl/assignments/$assignmentID',
     
      options: Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
    
      return {
        'success': true,
        'data': "تم الحذف بنجاح",
        'statusCode': response.statusCode,
      };
    } else {
      return {
        'success': false,
        'message': 'فشل الحذف',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    return {
      'success': false,
      'message': 'تحقق من اتصالك بالانترنت',
      'statusCode': e.response?.statusCode ?? "500",
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'حدث خطأ غير متوقع',
      'statusCode': 500,
    };
  }
}

