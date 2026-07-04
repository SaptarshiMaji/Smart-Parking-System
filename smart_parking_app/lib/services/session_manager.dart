import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {

  static Future<void> saveUser({

    required String name,

    required String email,
  }) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      "user_name",
      name,
    );

    await prefs.setString(
      "user_email",
      email,
    );

    await prefs.setBool(
      "is_logged_in",
      true,
    );
  }

  static Future<String> getUserEmail()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
            "user_email") ??
        "";
  }

  static Future<String> getUserName()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
            "user_name") ??
        "";
  }

  static Future<bool> isLoggedIn()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(
            "is_logged_in") ??
        false;
  }

  static Future<void> logout()
  async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.clear();
  }
}