import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { system, light, dark }

class SharedPreferencesService {
  static const String _keyTheme = 'theme';
  static const String _keyFirstTimeLaunch = 'firstTimeLaunch';
  static const String _fontSize = 'fontSize';
  static const String _fontFamily = 'fontFamily';

  static Future<void> saveTheme(AppThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTheme, themeMode.index);
  }

  static Future<AppThemeMode> getTheme() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final savedThemeIndex = sharedPreferences.getInt(_keyTheme) ?? AppThemeMode.system.index;
    return AppThemeMode.values[savedThemeIndex];
  }

  static Future<void> saveFirstTimeLaunch(bool isFirstTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFirstTimeLaunch, isFirstTime);
  }

  static Future<bool?> isFirstTimeLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFirstTimeLaunch);
  }

  static Future<void> saveFontSize(int fontValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_fontSize, fontValue);
  }

  static Future<int?> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_fontSize);
  }

  static Future<void> saveFontFamily(String fontFamily) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamily, fontFamily);
  }

  static Future<String?> getFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fontFamily);
  }
}
