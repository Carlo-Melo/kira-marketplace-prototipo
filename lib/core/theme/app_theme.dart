import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    const seed = Color(0xFF0D7E71);
    const accent = Color(0xFFF28E2B);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    ).copyWith(secondary: accent);
    final textTheme = GoogleFonts.urbanistTextTheme().copyWith(
      headlineMedium: GoogleFonts.urbanist(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
      titleLarge: GoogleFonts.urbanist(fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.urbanist(fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.urbanist(fontWeight: FontWeight.w500),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFFF7FBFA),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFEFF5F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
