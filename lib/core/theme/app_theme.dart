import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App theme system providing a modern, premium, minimalist aesthetic
/// using a refined blurple accent and clean slate backgrounds.
class AppTheme {
  static const Color blurple = Color(0xFF5B5FEF);
  static const Color blurpleLight = Color(0xFF7E81FF);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: blurple,
        onPrimary: Colors.white,
        secondary: const Color(0xFF7C3AED),
        tertiary: const Color(0xFF0EA5E9),
        error: const Color(0xFFEF4444),
        surface: const Color(0xFFFAFAFB),
        surfaceContainerLow: const Color(0xFFF3F4F6),
        surfaceContainerHigh: const Color(0xFFE5E7EB),
        onSurface: const Color(0xFF0F172A),
        outline: const Color(0xFFE2E8F0),
        outlineVariant: const Color(0xFFCBD5E1),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          letterSpacing: -0.1,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          letterSpacing: -0.1,
          height: 1.4,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF0F172A),
        iconTheme: IconThemeData(color: Color(0xFF0F172A)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
        backgroundColor: const Color(0xFFF8FAFC),
        selectedColor: blurple.withValues(alpha: 0.1),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF1F5F9)),
        ),
        color: const Color(0xFFFAFAFB),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: blurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF0F172A),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: blurpleLight,
        onPrimary: const Color(0xFF020205),
        secondary: const Color(0xFFA78BFA),
        tertiary: const Color(0xFF38BDF8),
        error: const Color(0xFFF87171),
        surface: const Color(0xFF0E111A),
        surfaceContainerLow: const Color(0xFF181B26),
        surfaceContainerHigh: const Color(0xFF232733),
        onSurface: const Color(0xFFF1F5F9),
        outline: const Color(0xFF1E293B),
        outlineVariant: const Color(0xFF334155),
      ),
      scaffoldBackgroundColor: const Color(0xFF06080D),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: const Color(0xFFF8FAFC),
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: const Color(0xFFF8FAFC),
        ),
        titleMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF1F5F9),
        ),
        bodyLarge: GoogleFonts.inter(
          letterSpacing: -0.1,
          height: 1.5,
          color: const Color(0xFFE2E8F0),
        ),
        bodyMedium: GoogleFonts.inter(
          letterSpacing: -0.1,
          height: 1.4,
          color: const Color(0xFFCBD5E1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFFF8FAFC),
        iconTheme: IconThemeData(color: Color(0xFFF8FAFC)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: const BorderSide(color: Color(0xFF1E293B)),
        backgroundColor: const Color(0xFF0F172A),
        selectedColor: blurpleLight.withValues(alpha: 0.15),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        color: const Color(0xFF0E111A),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF0E111A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: blurpleLight,
          foregroundColor: const Color(0xFF020205),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF8FAFC),
          side: const BorderSide(color: Color(0xFF1E293B)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
