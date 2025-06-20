import 'package:shared_preferences/shared_preferences.dart';

Future<void> setChatId(String chatId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('chatId', chatId); // Example chat ID, replace with actual logic
 
}
