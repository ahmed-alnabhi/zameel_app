import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Dio dio = Dio();

Future<Map<String, dynamic>> fetchStudentGroups({
  required String? token,
}) async {
  try {
    final response = await dio.get(
      '$baseUrl/users/me/groups',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Check if response.data is a List
      if (response.data is List) {
        // Extract IDs from each group
        final List<int> groupIds = (response.data as List)
            .map<int>((group) => group['id'] as int)
            .toList();

        return {
          'success': true,
          'data': groupIds, // Returns a List<int> of group IDs
          'statusCode': response.statusCode,
        };
      } else {
        return {
          'success': false,
          'message': 'Invalid data format: Expected a list of groups',
          'statusCode': response.statusCode,
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Failed to fetch data',
        'statusCode': response.statusCode,
      };
    }
  } on DioException catch (e) {
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'Connection error',
      'statusCode': e.response?.statusCode ?? 500,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: $e',
      'statusCode': 500,
    };
  }
}