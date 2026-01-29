import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color palette for Bro Leveling.
/// Dark theme with gold accents inspired by Solo Leveling.
abstract class AppColors {
  // Primary palette
  static const background = Color(0xFF1A1A1A);
  static const surface = Color(0xFF252525);
  static const surfaceLight = Color(0xFF333333);

  // Accent colors
  static const gold = Color(0xFFFFD700);
  static const goldDark = Color(0xFFB8860B);
  static const goldLight = Color(0xFFFFE55C);

  // Text colors
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0B0B0);
  static const textMuted = Color(0xFF707070);

  // Status colors
  static const success = Color(0xFF4CAF50);
  static const error = Color(0xFFE53935);
  static const warning = Color(0xFFFF9800);
  static const info = Color(0xFF2196F3);

  // Rank-based aura colors
  static const auraLow = Color(0xFF757575); // Gray (0-99)
  static const auraMedium = Color(0xFF4CAF50); // Green (100-499)
  static const auraHigh = Color(0xFF2196F3); // Blue (500-999)
  static const auraElite = Color(0xFF9C27B0); // Purple (1000-4999)
  static const auraLegend = Color(0xFFFFD700); // Gold (5000+)
  static const auraBroken = Color(0xFF424242); // Dark gray (0/Broken)
}

/// Main app theme for Bro Leveling.
ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.gold,
    secondary: AppColors.goldDark,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  textTheme: GoogleFonts.orbitronTextTheme()
      .apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      )
      .copyWith(
        // Override specific styles with Poppins for readability
        bodyLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.poppins(color: AppColors.textPrimary),
        bodySmall: GoogleFonts.poppins(color: AppColors.textSecondary),
        labelLarge: GoogleFonts.poppins(color: AppColors.textPrimary),
        labelMedium: GoogleFonts.poppins(color: AppColors.textSecondary),
      ),
  useMaterial3: true,

  // AppBar theme
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.orbitron(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
      letterSpacing: 2,
    ),
  ),

  // Input theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.surfaceLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.gold, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    labelStyle: const TextStyle(color: AppColors.textSecondary),
    hintStyle: const TextStyle(color: AppColors.textMuted),
  ),

  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.orbitron(
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    ),
  ),

  // Text button theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: AppColors.gold),
  ),

  // Floating action button theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.gold,
    foregroundColor: AppColors.background,
  ),

  // Card theme
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.surface,
    selectedColor: AppColors.gold,
    labelStyle: const TextStyle(color: AppColors.textPrimary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Snackbar theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.surface,
    contentTextStyle: const TextStyle(color: AppColors.textPrimary),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),

  // Dropdown theme
  dropdownMenuTheme: DropdownMenuThemeData(
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
