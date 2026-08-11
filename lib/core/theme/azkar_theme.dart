import 'package:flutter/material.dart';
import 'package:task_management/core/theme/app_text_theme.dart';

class AzkarTheme {
  // Colors - Updated based on the uploaded design
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color secondaryColor = Color(0xFF357ABD);
  static const Color darkBackground = Color(0xFF1A1D2E);
  static const Color darkSurface = Color(0xFF2A2D3E);
  static const Color lightBackground = Color(0xFFF4F6F9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1A1D2E);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      fontFamily: 'Cairo',
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: lightSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
          color: textPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      fontFamily: 'Cairo',
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: darkSurface,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
          color: textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}