import 'package:shared_preferences/shared_preferences.dart';

class ConstantFunctions {
  static String sharedUserNamekey = "USERNAMEKEY";
  static String sharedEmailkey = "EMAILKEY";

  static Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedUserNamekey, username);
  }

  static Future<bool> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedEmailkey, email);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedUserNamekey);
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedEmailkey);
  }
}
