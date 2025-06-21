import 'package:dio/dio.dart';
import 'package:zameel/core/networking/constant.dart';

Future<List<Map<String, dynamic>>> fetchGroupNamesAndSubjectIds(String token) async {
  try {
    final dio = Dio();

    final response = await dio.get(
      '$baseUrl/users/me/groups',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> groups = response.data;

      // دالة مساعدة لجلب اسم المادة بناء على subject_id
      Future<String> fetchSubjectName(int subjectId) async {
        final subjectResponse = await dio.get(
          '$baseUrl/subjects/$subjectId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        if (subjectResponse.statusCode == 200) {
          return subjectResponse.data['data']['name'] ?? 'غير معروف';
        } else {
          return 'غير معروف';
        }
      }

      // دالة مساعدة لجلب اسم التخصص بناء على major_id
      Future<String> fetchMajorName(int majorId) async {
        final majorResponse = await dio.get(
          '$baseUrl/majors/$majorId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ),
        );
        if (majorResponse.statusCode == 200) {
          return majorResponse.data['data']['name'] ?? 'غير معروف';
        } else {
          return 'غير معروف';
        }
      }

      // استدعاء لكل مجموعة لجلب الاسماء وتجميع النتيجة
      List<Map<String, dynamic>> result = [];

      for (var group in groups) {
        final groupId = group['id']; // ✅ استخراج group id
        final majorId = group['major_id'];
        final joinYear = group['join_year'];
        final division = group['division'];
        final subjectId = group['pivot']['subject_id'];

        final majorName = await fetchMajorName(majorId);
        final subjectName = await fetchSubjectName(subjectId);

        final groupName = '$majorName - $joinYear - $division';

        result.add({
          'group_id': groupId,          // ✅ إضافة group_id
          'group_name': groupName,
          'subject_id': subjectId,
          'subject_name': subjectName,
        });
      }

      return result;
    } else {
      throw Exception('فشل في جلب البيانات: ${response.statusCode}');
    }
  } catch (e) {
    print('حدث خطأ: $e');
    return [];
  }
}
