import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System: "Apple Human Interface" — Modern iOS UI Theme Specification
class AppTheme {
  // Apple System Accent (iOS Indigo / Blurple)
  static const Color appleIndigo = Color(0xFF5856D6);
  static const Color appleIndigoDark = Color(0xFF5E5CE6);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color appleBlueDark = Color(0xFF0A84FF);

  // Apple System Semantics
  static const Color appleGreen = Color(0xFF34C759);
  static const Color appleRed = Color(0xFFFF3B30);
  static const Color appleOrange = Color(0xFFFF9500);

  // Apple iOS Neutrals — Light Mode (Inset Grouped)
  static const Color bgLight = Color(0xFFF2F2F7); // System Grouped Background
  static const Color surfaceLight = Color(0xFFFFFFFF); // Secondary System Grouped
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE5E5EA); // System Separator
  static const Color textPrimaryLight = Color(0xFF000000);
  static const Color textSecondaryLight = Color(0xFF8E8E93);
  static const Color textTertiaryLight = Color(0xFFC7C7CC);

  // Apple iOS Neutrals — Dark Mode (OLED Inset Grouped)
  static const Color bgDark = Color(0xFF000000); // Pure Apple OLED Black
  static const Color surfaceDark = Color(0xFF1C1C1E); // Secondary System Grouped (Dark)
  static const Color surfaceElevatedDark = Color(0xFF2C2C2E); // Tertiary System Grouped
  static const Color borderDark = Color(0xFF38383A); // System Separator (Dark)
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);
  static const Color textTertiaryDark = Color(0xFF48484A);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: appleIndigo,
        onPrimary: Colors.white,
        secondary: appleBlue,
        tertiary: appleIndigo.withValues(alpha: 0.12),
        error: appleRed,
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
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: textPrimaryLight,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: textPrimaryLight,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: textPrimaryLight,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
          color: textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: textSecondaryLight,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryLight,
        iconTheme: IconThemeData(color: appleIndigo),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide.none,
        backgroundColor: borderLight.withValues(alpha: 0.5),
        selectedColor: appleIndigo.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderLight, width: 0.5),
        ),
        color: surfaceLight,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevatedLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: appleIndigo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appleIndigo,
          side: const BorderSide(color: borderLight, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: appleIndigo, width: 1.5),
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
        primary: appleIndigoDark,
        onPrimary: Colors.white,
        secondary: appleBlueDark,
        tertiary: appleIndigoDark.withValues(alpha: 0.15),
        error: appleRed,
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
          fontSize: 34,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8,
          color: textPrimaryDark,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: textPrimaryDark,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
          color: textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondaryDark,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondaryDark,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: textSecondaryDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimaryDark,
        iconTheme: IconThemeData(color: appleIndigoDark),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: BorderSide.none,
        backgroundColor: surfaceElevatedDark,
        selectedColor: appleIndigoDark.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderDark, width: 0.5),
        ),
        color: surfaceDark,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceElevatedDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: appleIndigoDark,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: appleIndigoDark,
          side: const BorderSide(color: borderDark, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          minimumSize: const Size(0, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevatedDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: appleIndigoDark, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 15, color: textSecondaryDark),
        hintStyle: GoogleFonts.inter(fontSize: 15, color: textTertiaryDark),
      ),
    );
  }
}
