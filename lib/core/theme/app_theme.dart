import 'package:flutter/material.dart';
import 'package:quira/core/theme/app_tokens.dart';

class AppTheme {
  AppTheme._();

  static const Color brand = Color(0xFFFF6B35);
  static const Color brandDark = Color(0xFFD9481E);
  static const Color accent = Color(0xFF2EC4B6);
  static const Color surface = Color(0xFFF9FAFB);
  static const Color ink = Color(0xFF1F2937);
  static const Color muted = Color(0xFF6B7280);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: brand,
            brightness: Brightness.light,
          ).copyWith(
            primary: brand,
            onPrimary: Colors.white,
            secondary: accent,
            surface: Colors.white,
          ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: brand,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brand,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(AppSizes.buttonMinHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: AppFontSizes.body,
            letterSpacing: 0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        side: BorderSide.none,
        selectedColor: brand.withValues(alpha: 0.14),
      ),
      dividerColor: const Color(0xFFE5E7EB),
    );
  }
}
