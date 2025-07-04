import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<List<Map<String, dynamic>>> getsubjectById({
  required String token,
  required int subjectId,
}) async {
  try {
    final dio = Dio();
    final response = await dio.get(
      '$baseUrl/subjects/$subjectId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List data = response.data['data'];
    
    final List<Map<String, dynamic>> subjects = data.map((teacher) {
      final subject = teacher['subject'];
      return {
        'id': subject['id'],
        'name': subject['name'],
      };
    }).toList();

    return subjects;

    }else {
      throw Exception('Failed to fetch subjects');
    }
  } catch (e) {
    print('Error fetching subjects: $e');
    return [];
  }
}
