import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';
import 'package:zameel/core/models/post_model.dart';

class PostService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<Map<String, dynamic>> fetchPostsService({
   required String? token,
   required String? cursor,
    bool? before,
  }) async {
    try {
      final response = await _dio.get(
        '/posts',
        queryParameters: {'cursor': cursor, 'before': before},

      
        options: Options(
          headers: {
            'Authorization':
                'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final posts =
            (data['data'] as List)
                .map((post) => PostModel.fromJson(post))
                .toList();

        return {
          'success': true,
          'data': posts,
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'فشل جلب البيانات',
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

}
