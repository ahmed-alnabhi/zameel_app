String formatTimeAgo(String dateTimeStr) {
  final dateTime = DateTime.parse(dateTimeStr).toLocal();
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return difference.inSeconds <= 1 ? 'منذ ثانية' : 'منذ ${difference.inSeconds} ثواني';
  } else if (difference.inMinutes < 60) {
    return difference.inMinutes == 1 ? 'منذ دقيقة' : 'منذ ${difference.inMinutes} دقيقة';
  } else if (difference.inHours < 24) {
    return difference.inHours == 1 ? 'منذ ساعة' : 'منذ ${difference.inHours} ساعات';
  } else if (difference.inDays < 7) {
    return difference.inDays == 1 ? 'منذ يوم' : 'منذ ${difference.inDays} أيام';
  } else {
    // إذا مرت أكثر من 7 أيام نرجع التاريخ بصيغة YYYY-MM-DD
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
