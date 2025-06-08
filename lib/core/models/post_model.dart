import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

String filesBaseUrl = 'https://zameel.s3.amazonaws.com/';

class PostFile {
  final List<String> urls; // روابط متعددة لكل ملف
  final String type; // 'image', 'video', 'document'
  final String ext; // 'png', 'jpg', 'pdf'
  final String name; // الاسم الأصلي للملف

  PostFile({
    required this.urls,
    required this.type,
    required this.ext,
    required this.name,
  });

  factory PostFile.fromJson(Map<String, dynamic> json) {
    return PostFile(
      urls: _parseUrls(json['url']),
      type: json['type']?.toString().toLowerCase() ?? 'file',
      ext: json['ext']?.toString().toLowerCase() ?? '',
      name: json['name']?.toString() ?? 'ملف بدون اسم',
    );
  }

  static List<String> _parseUrls(dynamic urlData) {
    if (urlData == null) return [];
    if (urlData is String) return [urlData];
    if (urlData is List) {
      return urlData
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return [];
  }

  // رابط أساسي (للتوافق مع الإصدارات القديمة)
  String get primaryUrl => urls.isNotEmpty ? urls.first : '';

  // هل الملف صورة؟
  bool get isImage => type == 'image';

  bool get isFile => type == 'file';
  bool get isPdf => ext == 'pdf';
  bool get isDocs => ext == 'docx';
  bool get isSlideShow => ext == 'pptx';
  bool get isExcel => ext == 'xlsx' || ext == 'xls';
  bool get isText => ext == 'txt';
  bool get isArchive => ['zip', 'rar', '7z'].contains(ext);

  bool get isDocument =>
      isPdf || isDocs || isSlideShow || isExcel || isText || isArchive;

  Map<String, dynamic> toJson() {
    return {'urls': urls, 'type': type, 'ext': ext, 'name': name};
  }
}

class PostModel {
  final int id;
  final String authorName;
  final int authorRollID;
  final String content;
  final DateTime createdAt;
  final List<PostFile> files;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorRollID,
    required this.content,
    required this.createdAt,
    required this.files,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    try {
      return PostModel(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        authorName: json['user']?['name']?.toString() ?? 'مستخدم مجهول',
        authorRollID:
            int.tryParse(json['user']?['role_id']?.toString() ?? '') ?? 0,
        content: json['content']?.toString() ?? '',
        createdAt: DateTime.parse(
          json['created_at']?.toString() ?? DateTime.now().toString(),
        ),
        files:
            (json['files'] as List<dynamic>?)
                ?.map((file) => PostFile.fromJson(file))
                .where((file) => file.urls.isNotEmpty)
                .toList() ??
            [],
      );
    } catch (e) {
      debugPrint('Error parsing post: $e');
      rethrow;
    }
  }

  // هل البوست يحتوي على صور؟
  bool get hasImages => files.any((file) => file.isImage);

  // الحصول على جميع الصور فقط
  List<PostFile> get imageFiles => files.where((file) => file.isImage).toList();
  // هل البوست يحتوي على ملفات مستندات (pdf, docx, pptx, xlsx, txt, ... )؟
  bool get hasDocuments => files.any((file) => file.isDocument);

  // الحصول على جميع ملفات المستندات فقط
  List<PostFile> get documentFiles =>
      files.where((file) => file.isDocument).toList();

  // تنسيق التاريخ بشكل جميل
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) return 'الآن';
    if (difference.inMinutes < 60) return 'منذ ${difference.inMinutes} دقيقة';
    if (difference.inHours < 24) return 'منذ ${difference.inHours} ساعة';
    if (difference.inDays < 7) return 'منذ ${difference.inDays} يوم';

    return DateFormat('yyyy/MM/dd').format(createdAt);
  }
}





















// class PostModel {
//   final String authorName;
//   final int roleId;
//   final String date;
//   final String content;
//   final List<String> files;

//   PostModel({
//     required this.authorName,
//     required this.roleId,
//     required this.date,
//     required this.content,
//     required this.files,
//   });

//   factory PostModel.fromJson(Map<String, dynamic> json) {
//     return PostModel(
//       authorName: json['user']['name'] ?? 'غير معروف',
//       roleId: json['user']['role_id'] ?? 0,
//       date: json['created_at'] ?? 'تاريخ غير متاح',
//       content: json['content'] ?? 'لا يوجد محتوى',
//       files: (json['files'] as List<dynamic>?)
//           ?.map((file) => file['url'] as String?)
//           .where((url) => url != null)
//           .cast<String>()
//           .toList() ?? [],
//     );
//   }
// }