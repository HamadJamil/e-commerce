import 'package:e_commerce/core/theme/app_theme.dart';
import 'package:e_commerce/core/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  static const String _isDarkModeKey = 'is_dark_mode';

  String _currentThemeKey = 'ocean_blue';
  bool _isDarkMode = false;

  String get currentThemeKey => _currentThemeKey;
  bool get isDarkMode => _isDarkMode;
  AppTheme get currentTheme => ThemeManager.getTheme(_currentThemeKey);

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currentThemeKey = prefs.getString(_themeKey) ?? 'ocean_blue';
    _isDarkMode = prefs.getBool(_isDarkModeKey) ?? false;
    notifyListeners();
  }

  Future<void> setTheme(String themeKey) async {
    _currentThemeKey = themeKey;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeKey);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, _isDarkMode);
    notifyListeners();
  }

  ThemeData get currentThemeData {
    return _isDarkMode ? currentTheme.darkTheme : currentTheme.lightTheme;
  }
}
