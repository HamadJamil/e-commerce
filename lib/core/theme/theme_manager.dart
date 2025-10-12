// lib/core/theme/theme_manager.dart
import 'dart:ui';

import 'app_theme.dart';

class ThemeManager {
  static final Map<String, AppTheme> _themes = {
    'ocean_blue': AppTheme(
      name: 'Ocean Blue',
      emoji: '🌊',
      light: AppColorScheme(
        primary: Color(0xFF1976D2),
        background: Color(0xFFFFFFFF),
        accent: Color(0xFF64B5F6),
        text: Color(0xFF000000),
        card: Color(0xFFF5F5F5),
        error: Color(0xFFD32F2F),
        success: Color(0xFF388E3C),
        warning: Color(0xFFF57C00),
      ),
      dark: AppColorScheme(
        primary: Color(0xFF90CAF9),
        background: Color(0xFF0D1117),
        accent: Color(0xFF42A5F5),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF161B22),
        error: Color(0xFFCF6679),
        success: Color(0xFF81C784),
        warning: Color(0xFFFFB74D),
      ),
    ),
    'pink_blossom': AppTheme(
      name: 'Pink Blossom',
      emoji: '🌸',
      light: AppColorScheme(
        primary: Color(0xFFE91E63),
        background: Color(0xFFFFF0F6),
        accent: Color(0xFFF48FB1),
        text: Color(0xFF000000),
        card: Color(0xFFFFF5F8),
        error: Color(0xFFD32F2F),
        success: Color(0xFF388E3C),
        warning: Color(0xFFF57C00),
      ),
      dark: AppColorScheme(
        primary: Color(0xFFF48FB1),
        background: Color(0xFF1B1B1B),
        accent: Color(0xFFEC407A),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF252525),
        error: Color(0xFFCF6679),
        success: Color(0xFF81C784),
        warning: Color(0xFFFFB74D),
      ),
    ),
    'golden_glow': AppTheme(
      name: 'Golden Glow',
      emoji: '☀️',
      light: AppColorScheme(
        primary: Color(0xFFFBC02D),
        background: Color(0xFFFFFDE7),
        accent: Color(0xFFFFD54F),
        text: Color(0xFF000000),
        card: Color(0xFFFFF9C4),
        error: Color(0xFFD32F2F),
        success: Color(0xFF388E3C),
        warning: Color(0xFFF57C00),
      ),
      dark: AppColorScheme(
        primary: Color(0xFFFFEE58),
        background: Color(0xFF1C1A00),
        accent: Color(0xFFFDD835),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF2A2800),
        error: Color(0xFFCF6679),
        success: Color(0xFF81C784),
        warning: Color(0xFFFFB74D),
      ),
    ),
    'forest_green': AppTheme(
      name: 'Forest Green',
      emoji: '🌿',
      light: AppColorScheme(
        primary: Color(0xFF388E3C),
        background: Color(0xFFE8F5E9),
        accent: Color(0xFF66BB6A),
        text: Color(0xFF000000),
        card: Color(0xFFC8E6C9),
        error: Color(0xFFD32F2F),
        success: Color(0xFF388E3C),
        warning: Color(0xFFF57C00),
      ),
      dark: AppColorScheme(
        primary: Color(0xFF81C784),
        background: Color(0xFF0A1A0A),
        accent: Color(0xFF4CAF50),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF1A2A1A),
        error: Color(0xFFCF6679),
        success: Color(0xFF81C784),
        warning: Color(0xFFFFB74D),
      ),
    ),
    'lavender_dream': AppTheme(
      name: 'Lavender Dream',
      emoji: '💜',
      light: AppColorScheme(
        primary: Color(0xFF9575CD),
        background: Color(0xFFF3E5F5),
        accent: Color(0xFFB39DDB),
        text: Color(0xFF000000),
        card: Color(0xFFEDE7F6),
        error: Color(0xFFD32F2F),
        success: Color(0xFF388E3C),
        warning: Color(0xFFF57C00),
      ),
      dark: AppColorScheme(
        primary: Color(0xFFB39DDB),
        background: Color(0xFF1E1B2E),
        accent: Color(0xFF7E57C2),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF2D2A3E),
        error: Color(0xFFCF6679),
        success: Color(0xFF81C784),
        warning: Color(0xFFFFB74D),
      ),
    ),
    'mint_breeze': AppTheme(
      name: 'Mint Breeze',
      emoji: '🧊',
      light: AppColorScheme(
        primary: Color(0xFF4DB6AC),
        background: Color(0xFFE0F2F1),
        accent: Color(0xFF80CBC4),
        text: Color(0xFF000000),
        card: Color(0xFFB2DFDB),
        error: Color(0xFFD32F2F),
        success: Color(0xFF388E3C),
        warning: Color(0xFFF57C00),
      ),
      dark: AppColorScheme(
        primary: Color(0xFF80CBC4),
        background: Color(0xFF001F24),
        accent: Color(0xFF26A69A),
        text: Color(0xFFFFFFFF),
        card: Color(0xFF00363D),
        error: Color(0xFFCF6679),
        success: Color(0xFF81C784),
        warning: Color(0xFFFFB74D),
      ),
    ),
  };

  static AppTheme getTheme(String key) {
    return _themes[key] ?? _themes['ocean_blue']!;
  }

  static List<AppTheme> get allThemes => _themes.values.toList();
  static List<String> get themeKeys => _themes.keys.toList();

  // Helper method to get theme by index
  static AppTheme getThemeByIndex(int index) {
    if (index >= 0 && index < _themes.length) {
      return _themes.values.elementAt(index);
    }
    return _themes['ocean_blue']!;
  }

  // Helper method to get theme key by index
  static String getThemeKeyByIndex(int index) {
    if (index >= 0 && index < _themes.length) {
      return _themes.keys.elementAt(index);
    }
    return 'ocean_blue';
  }

  // Helper method to get theme index by key
  static int getThemeIndex(String key) {
    return _themes.keys.toList().indexOf(key);
  }
}
