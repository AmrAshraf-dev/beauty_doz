import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  static const String token = 'token';
  static const String currncy = 'currncy';
  static const String fcmToken = 'fcmToken';
  static const String refreshToken = 'refreshToken';
  static const String appSettings = 'appSettings';
  static const String languageCode = 'language_code';
  static const String firstLaunch = 'firstLaunch';
  static const String loggedIn = 'loggedIn';
  static const String isDark = 'isDark';
  static const String userData = 'userData';
  static const String userLogged = 'userLogged';
  static const String baseUrl = 'baseUrl';
}

class Preference {
  static SharedPreferences sb;
  static Future<void> init() async {
    if (sb == null) sb = await SharedPreferences.getInstance();
  }

  static String getString(String key) {
    try {
      return sb.getString(key);
    } catch (e) {
      return null;
    }
  }

  static int getInt(String key) {
    try {
      return sb.getInt(key);
    } catch (e) {
      return null;
    }
  }

  static bool getBool(String key) {
    try {
      return sb.getBool(key);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setString(String key, String value) async {
    final sb = await SharedPreferences.getInstance();
    try {
      return sb.setString(key, value);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setInt(String key, int value) async {
    try {
      return sb.setInt(key, value);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    try {
      print(key);
      return await sb.setBool(key, value);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> remove(String key) async {
    try {
      return await sb.remove(key);
    } catch (e) {
      return null;
    }
  }

  static Future<bool> clear() async {
    try {
      return await sb.clear();
    } catch (e) {
      return null;
    }
  }
}
