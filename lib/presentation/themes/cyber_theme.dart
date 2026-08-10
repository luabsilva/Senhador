import 'package:flutter/material.dart';

import 'app_typography.dart';

class CyberTheme {
  static const Color background = Color(0xFF080D0A);
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color emeraldActive = Color(0xFF059669);
  static const Color accentText = Color(0xFFD1FAE5);
  static const Color surfaceDark = Color(0xFF050C08);
  static const Color glassFill = Color(0xFF0F1A14);
  static const Color borderDark = Color(0xFF1E3A2B);
  static const Color borderHighlight = Color(0xFF10B981);
  static const Color surfaceSoft = Color(0xFF0A1710);

  static ThemeData get theme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: emeraldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: emeraldPrimary,
        secondary: emeraldActive,
        surface: glassFill,
        onSurface: accentText,
        onPrimary: Colors.black,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: accentText,
        displayColor: accentText,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.title,
        iconTheme: const IconThemeData(color: accentText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark.withValues(alpha: 220),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        labelStyle: AppTypography.label,
        hintStyle: AppTypography.caption,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: emeraldPrimary,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: AppTypography.button,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return emeraldPrimary;
          }
          return const Color(0xFF64748B);
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF064E3B);
          }
          return const Color(0xFF1A2E22);
        }),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: emeraldPrimary,
        inactiveTrackColor: Color(0xFF0D1A12),
        thumbColor: emeraldPrimary,
        overlayColor: Color(0x3310B981),
        trackHeight: 8.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF0F1A14).withValues(alpha: 242),
        contentTextStyle: AppTypography.label,
      ),
    );
  }

  static BoxDecoration get glassCardDecoration => BoxDecoration(
        color: glassFill.withValues(alpha: 217),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: borderDark.withValues(alpha: 140),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 170),
            blurRadius: 34.0,
            offset: const Offset(0, 16),
          ),
        ],
      );

  static BoxDecoration get glassSurfaceDecoration => BoxDecoration(
        color: surfaceDark.withValues(alpha: 204),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderDark.withValues(alpha: 120),
        ),
      );

  static BoxDecoration get pageBackground => const BoxDecoration(
        color: background,
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          colors: [
            Color(0x2610B981),
            Color(0x00080D0A),
          ],
          stops: [0.0, 0.65],
        ),
      );
}
