GLASSMORPHIC CYBER DESIGN SYSTEM (FLUTTER) // 

1. Design Philosophy
This system bridges classic cyberpunk aesthetic with modern mobile UX. It trades harsh high-contrast CRT styling for deep translucent surfaces (glassmorphic dark emeralds), subtle neon accents, rounded corners, and monospaced typography reserved for critical data entries.
Target Platforms: Android, iOS, Web Responsive.

2. Color Tokens
Primary & Accent Colors
Emerald Glow: #10B981 (Primary actions, active switches, high score indicators)
Emerald Hover/Active: #059669 (Pressed button states, borders)
Emerald Text Highlight: #D1FAE5 (Primary titles, output text)
Muted Green: #6EE7B7 (Secondary labels, metadata)
Backgrounds & Glass Surfaces
App Background: #080D0A (Deep dark emerald charcoal)
Glass Card Fill: rgba(15, 26, 20, 0.85) (Main container blur overlay)
Glass Input Fill: rgba(5, 12, 8, 0.80) (Output fields, option rows)
Border Default: rgba(30, 58, 43, 0.80)
Border Highlight: rgba(16, 185, 129, 0.22)
Utility Colors
Error / Weak Password: #EF4444
Warning / Moderate: #F59E0B
Surface Dark: #050C08

3. Typography Rules
Font combination relies on two Google Fonts:
Primary Interface: GoogleFonts.inter() (Used for general labels, option descriptions, headers)
Technical & Output: GoogleFonts.firaCode() (Used for passwords, sliders length values, buttons, strength indicators)
Text Styles Definition
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle title = GoogleFonts.firaCode(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFD1FAE5),
    letterSpacing: 1.2,
  );

  static TextStyle passwordOutput = GoogleFonts.firaCode(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF10B981),
    letterSpacing: 1.5,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFE2E8F0),
  );

  static TextStyle caption = GoogleFonts.firaCode(
    fontSize: 11,
    color: const Color(0xFF6EE7B7),
  );
}


4. Geometry & Elevation Tokens
Main Card Radius: 24.0 (BorderRadius.circular(24))
Input & Control Radius: 16.0 (BorderRadius.circular(16))
Button Radius: 16.0 (BorderRadius.circular(16))
Badge Radius: 999.0 (Full pill shape)
Glassmorphism Card Decoration
import 'package:flutter/material.dart';

BoxDecoration get glassCardDecoration => BoxDecoration(
      color: const Color(0xFF0F1A14).withOpacity(0.85),
      borderRadius: BorderRadius.circular(24.0),
      border: Border.all(
        color: const Color(0xFF10B981).withOpacity(0.22),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.60),
          blurRadius: 50.0,
          spreadRadius: 0.0,
          offset: const Offset(0, 20),
        ),
        BoxShadow(
          color: const Color(0xFF10B981).withOpacity(0.08),
          blurRadius: 30.0,
          spreadRadius: 0.0,
        ),
      ],
    );


5. Flutter Theme Implementation
import 'package:flutter/material.dart';

class CyberTheme {
  static const Color background = Color(0xFF080D0A);
  static const Color emeraldPrimary = Color(0xFF10B981);
  static const Color borderDark = Color(0xFF1E3A2B);

  static ThemeData get theme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: emeraldPrimary,
      colorScheme: const ColorScheme.dark(
        primary: emeraldPrimary,
        surface: Color(0xFF0F1A14),
        onSurface: Color(0xFFE2E8F0),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return emeraldPrimary;
          }
          return const Color(0xFF64748B);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF064E3B);
          }
          return const Color(0xFF1A2E22);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return emeraldPrimary;
          }
          return const Color(0xFF2A4A37);
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: emeraldPrimary,
        inactiveTrackColor: const Color(0xFF0D1A12),
        thumbColor: emeraldPrimary,
        overlayColor: emeraldPrimary.withOpacity(0.2),
        trackHeight: 8.0,
      ),
    );
  }
}