import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System: "Pulse" — Modern NFC App UI Theme Specification
class AppTheme {
  // Accent Colors
  static const Color accent500 = Color(0xFF5B5FEF);
  static const Color accent600 = Color(0xFF4548D9);
  static const Color accent400 = Color(0xFF7B7FF5);
  static const Color accent100 = Color(0xFFEDEEFE);
  static final Color accentGlow = const Color(
    0xFF5B5FEF,
  ).withValues(alpha: 0.25);

  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Light Mode Colors
  static const Color bgLight = Color(0xFFFAFAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFECECF2);
  static const Color textPrimaryLight = Color(0xFF111114);
  static const Color textSecondaryLight = Color(0xFF6B6B76);
  static const Color textTertiaryLight = Color(0xFFA6A6B0);

  // Dark Mode Colors
  static const Color bgDark = Color(0xFF0B0B0F);
  static const Color surfaceDark = Color(0xFF17171D);
  static const Color surfaceElevatedDark = Color(0xFF1E1E26);
  static const Color borderDark = Color(0xFF28282F);
  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryDark = Color(0xFF9A9AA5);
  static const Color textTertiaryDark = Color(0xFF5C5C66);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: accent500,
        onPrimary: Colors.white,
        secondary: accent400,
        tertiary: accent100,
        error: error,
        surface: surfaceLight,
        surfaceContainerLow: surfaceLight,
        surfaceContainerHigh: surfaceElevatedLight,
        onSurface: textPrimaryLight,
        outline: borderLight,
        outlineVariant: textTertiaryLight,
      ),
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.02 * 32,
          color: textPrimaryLight,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.01 * 24,
          color: textPrimaryLight,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textSecondaryLight,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: 0.01 * 13,
          color: textSecondaryLight,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.04 * 11,
          color: textTertiaryLight,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryLight,
        iconTheme: IconThemeData(color: textPrimaryLight),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: borderLight, width: 1.5),
        backgroundColor: surfaceLight,
        selectedColor: accent100,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 1.5),
        ),
        color: surfaceLight,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevatedLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: accent500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryLight,
          side: const BorderSide(color: borderLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderLight, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderLight, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent500, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 15, color: textSecondaryLight),
        hintStyle: GoogleFonts.inter(fontSize: 15, color: textTertiaryLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: accent500,
        onPrimary: Colors.white,
        secondary: accent400,
        tertiary: accent500.withValues(alpha: 0.15),
        error: error,
        surface: surfaceDark,
        surfaceContainerLow: surfaceDark,
        surfaceContainerHigh: surfaceElevatedDark,
        onSurface: textPrimaryDark,
        outline: borderDark,
        outlineVariant: textTertiaryDark,
      ),
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.02 * 32,
          color: textPrimaryDark,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.25,
          letterSpacing: -0.01 * 24,
          color: textPrimaryDark,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: textSecondaryDark,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: 0.01 * 13,
          color: textSecondaryDark,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          height: 1.3,
          letterSpacing: 0.04 * 11,
          color: textTertiaryDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryDark,
        iconTheme: IconThemeData(color: textPrimaryDark),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: borderDark, width: 1.5),
        backgroundColor: surfaceDark,
        selectedColor: accent500.withValues(alpha: 0.15),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderDark, width: 1.5),
        ),
        color: surfaceDark,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevatedDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: accent500,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryDark,
          side: const BorderSide(color: borderDark, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderDark, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: borderDark, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: accent500, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 15, color: textSecondaryDark),
        hintStyle: GoogleFonts.inter(fontSize: 15, color: textTertiaryDark),
      ),
    );
  }
}
