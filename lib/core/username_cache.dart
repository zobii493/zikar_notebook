import 'package:shared_preferences/shared_preferences.dart';

class UsernameCache {
  UsernameCache._();

  static const _kKey = 'cached_username';

  static String? value;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getString(_kKey);
  }

  static Future<void> save(String username) async {
    value = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, username);
  }
}