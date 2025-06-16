import 'package:shared_preferences/shared_preferences.dart';

Future<int> getRoll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   final roll = prefs.getInt('roll');
   return roll ?? 0; // Return 0 if roll is not found
  }