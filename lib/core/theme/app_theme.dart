import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Palette
  static const darkBackground = Color(0xFF0F0F0F);
  static const darkSurface = Color(0xFF1A1A1A);
  static const darkAccent = Color(0xFFE8D5B7);

  // Light Palette
  static const lightBackground = Color(0xFFFAFAF8);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightAccent = Color(0xFF4A3728);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightAccent,
        brightness: Brightness.light,
        surface: lightSurface,
        onSurface: lightAccent,
        primary: lightAccent,
      ).copyWith(surface: lightBackground),
      scaffoldBackgroundColor: lightBackground,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.lora(fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.lora(fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.lora(fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.lora(fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.lora(fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.lora(fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.lora(fontWeight: FontWeight.bold),
        titleMedium: GoogleFonts.lora(fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.lora(fontWeight: FontWeight.w600),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkAccent,
        brightness: Brightness.dark,
        surface: darkSurface,
        onSurface: darkAccent,
        primary: darkAccent,
      ).copyWith(surface: darkBackground),
      scaffoldBackgroundColor: darkBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            displayMedium: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            displaySmall: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            headlineLarge: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            headlineMedium: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            headlineSmall: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            titleLarge: GoogleFonts.lora(
              fontWeight: FontWeight.bold,
              color: darkAccent,
            ),
            titleMedium: GoogleFonts.lora(
              fontWeight: FontWeight.w600,
              color: darkAccent,
            ),
            titleSmall: GoogleFonts.lora(
              fontWeight: FontWeight.w600,
              color: darkAccent,
            ),
          ),
    );
  }
}
