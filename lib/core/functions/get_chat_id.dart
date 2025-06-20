import 'package:shared_preferences/shared_preferences.dart';

Future<String> getChatId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
 final String? chatId = prefs.getString('chatId'); // Example chat ID, replace with actual logic
  return chatId ?? "";
}
