// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color secondary = Color(0xFFFF6584);
  static const Color accent = Color(0xFF43E97B);
  static const Color warning = Color(0xFFFFB347);

  // Priority Colors
  static const Color priorityHigh = Color(0xFFFF4757);
  static const Color priorityMedium = Color(0xFFFFB347);
  static const Color priorityLow = Color(0xFF2ED573);

  // Category Colors
  static const List<Color> categoryColors = [
    Color(0xFF6C63FF), // Personal
    Color(0xFF3742FA), // Work
    Color(0xFFFF6B81), // Shopping
    Color(0xFF2ED573), // Health
    Color(0xFFFFB347), // Education
    Color(0xFF747D8C), // Other
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      fontFamily: 'Vazirmatn',
      scaffoldBackgroundColor: const Color(0xFFF8F9FF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Color(0xFF2D3436),
        titleTextStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D3436),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          color: Color(0xFFADB5BD),
          fontFamily: 'Vazirmatn',
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.transparent;
        }),
        side: const BorderSide(color: Color(0xFFADB5BD), width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFF0EFFF),
        selectedColor: primary,
        labelStyle: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      fontFamily: 'Vazirmatn',
      scaffoldBackgroundColor: const Color(0xFF0F0F1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: const Color(0xFF1E1E2E),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  // Priority color helper
  static Color priorityColor(int priorityIndex) {
    switch (priorityIndex) {
      case 0:
        return priorityLow;
      case 1:
        return priorityMedium;
      case 2:
        return priorityHigh;
      default:
        return priorityMedium;
    }
  }

  // Category color helper
  static Color categoryColor(int categoryIndex) {
    return categoryColors[categoryIndex % categoryColors.length];
  }
}
