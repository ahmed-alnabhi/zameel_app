import 'package:flutter/material.dart';

Color getColorByExtension(String extension) {
  switch (extension.toLowerCase()) {
    case 'pdf':
      return Colors.red;
    case 'doc':
    case 'docx':
      return Colors.blue;
    case 'ppt':
    case 'pptx':
      return Colors.orange;
    case 'xls':
    case 'xlsx':
      return Colors.green;
    case 'txt':
      return Colors.grey;
    case 'zip':
    case 'rar':
    case '7z':
      return Colors.brown;
    case 'mp4':
    case 'avi':
    case 'mov':
    case 'mkv':
      return Colors.deepPurple;
    case 'html':
    case 'css':
    case 'js':
      return Colors.teal;
    case 'dart':
      return Colors.lightBlue;
    case 'cpp':
    case 'c':
    case 'h':
      return Colors.indigo;
    case 'json':
    case 'xml':
      return Colors.amber;
    case 'apk':
      return Colors.greenAccent;
    case 'exe':
    case 'msi':
      return Colors.black;
    default:
      return Colors.black45; // لون افتراضي في حال صيغة غير معروفة
  }
}
