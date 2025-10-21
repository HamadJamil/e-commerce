
import 'package:e_commerce/core/theme/text_style_helper.dart';
import 'package:flutter/material.dart';

class AppColorScheme {
  final Color primary;
  final Color background;
  final Color accent;
  final Color text;
  final Color card;
  final Color error;
  final Color success;
  final Color warning;

  const AppColorScheme({
    required this.primary,
    required this.background,
    required this.accent,
    required this.text,
    required this.card,
    required this.error,
    required this.success,
    required this.warning,
  });
}

class AppTheme {
  final String name;
  final AppColorScheme light;
  final AppColorScheme dark;
  final String emoji;

  const AppTheme({
    required this.name,
    required this.light,
    required this.dark,
    required this.emoji,
  });

  ThemeData get lightTheme => _createTheme(light, Brightness.light);
  ThemeData get darkTheme => _createTheme(dark, Brightness.light);

  ThemeData _createTheme(AppColorScheme colors, Brightness brightness) {
    final textTheme = _createTextTheme(colors, brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        primary: colors.primary,
        onPrimary: Colors.white,
        secondary: colors.accent,
        onSecondary: Colors.white,
        surface: colors.card,
        onSurface: colors.text,
        background: colors.background,
        onBackground: colors.text,
        error: colors.error,
        onError: Colors.white,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: textTheme.headline6?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colors.text.withValues(alpha: 0.7)),
        hintStyle: TextStyle(color: colors.text.withValues(alpha: 0.5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: textTheme.button?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      textTheme: textTheme,
      iconTheme: IconThemeData(color: colors.text.withValues(alpha: .8)),
      listTileTheme: ListTileThemeData(
        iconColor: colors.text.withValues(alpha: 0.8),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
      dividerTheme: DividerThemeData(
        color: colors.text.withValues(alpha: 0.2),
        thickness: 1,
        space: 1,
      ),
    );
  }

  TextTheme _createTextTheme(AppColorScheme colors, Brightness brightness) {
    final baseTextStyle = TextStyle(color: colors.text, fontFamily: 'Inter');

    return TextTheme(
      displayLarge: baseTextStyle.copyWith(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 1.12,
        letterSpacing: -0.25,
      ),
      displayMedium: baseTextStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 1.16,
      ),
      displaySmall: baseTextStyle.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 1.22,
      ),
      headlineLarge: baseTextStyle.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
      headlineMedium: baseTextStyle.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 1.29,
      ),
      headlineSmall: baseTextStyle.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
      titleLarge: baseTextStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.27,
      ),
      titleMedium: baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.15,
      ),
      titleSmall: baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      bodyLarge: baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
      ),
      bodyMedium: baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
      ),
      bodySmall: baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
      ),
      labelLarge: baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      labelMedium: baseTextStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.33,
        letterSpacing: 0.5,
      ),
      labelSmall: baseTextStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0.5,
      ),
    );
  }
}
