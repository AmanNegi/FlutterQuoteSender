import 'package:shared_preferences/shared_preferences.dart';

class UserUtils {
 static SharedPreferences _sharedPreferences;

  static Future<void> _initSharedPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

 static Future<void> saveToSharedPrefs(String key, dynamic value) async {
    await _initSharedPrefs();
    _sharedPreferences.setString(key, value);
  }

  static Future<bool> checkIfExists(String key) async {
    await _initSharedPrefs();
    return _sharedPreferences.containsKey(key);
  }

 static Future<String> getFromSharedPrefs(String key) async {
    await _initSharedPrefs();
    return _sharedPreferences.getString(key);
  }
}
