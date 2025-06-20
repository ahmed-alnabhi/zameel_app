String daysLeftOrDate(String dateTimeString) {
  DateTime inputDate = DateTime.parse(dateTimeString).toLocal();
  DateTime now = DateTime.now();
  int difference =
      inputDate.difference(DateTime(now.year, now.month, now.day)).inDays;

  if (difference > 0) {
    return "تبقى $difference ${difference == 1 ? 'يوم' : 'أيام'}";
  } else {
    return inputDate.toIso8601String().split('T')[0];
  }
}
