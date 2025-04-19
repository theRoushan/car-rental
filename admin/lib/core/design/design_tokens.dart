import 'package:flutter/material.dart';

class DesignTokens {
  // Colors - Modern and vibrant palette
  static const primary = Color(0xFF6366F1);  // Indigo
  static const primaryLight = Color(0xFFA5B4FC);
  static const primaryDark = Color(0xFF4338CA);
  
  static const secondary = Color(0xFF10B981);  // Emerald
  static const secondaryLight = Color(0xFF6EE7B7);
  static const secondaryDark = Color(0xFF059669);
  
  static const success = Color(0xFF34D399);  // Modern green
  static const error = Color(0xFFEF4444);    // Modern red
  static const warning = Color(0xFFF59E0B);  // Modern amber
  static const info = Color(0xFF3B82F6);     // Modern blue

  // Light Theme Colors - Clean and minimal
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightSurface = Colors.white;
  static const lightText = Color(0xFF1E293B);
  static const lightTextSecondary = Color(0xFF64748B);
  static const lightDivider = Color(0xFFE2E8F0);
  
  // Dark Theme Colors - Elegant dark mode
  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkText = Color(0xFFF8FAFC);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkDivider = Color(0xFF334155);

  // Refined Spacing Scale
  static const spaceXXS = 4.0;
  static const spaceXS = 8.0;
  static const spaceSM = 12.0;
  static const spaceMD = 16.0;
  static const spaceLG = 24.0;
  static const spaceXL = 32.0;
  static const spaceXXL = 40.0;

  // Modern Border Radius
  static const radiusXS = 6.0;
  static const radiusSM = 8.0;
  static const radiusMD = 12.0;
  static const radiusLG = 16.0;
  static const radiusXL = 24.0;
  static const radiusCircular = 999.0;

  // Refined Elevation
  static List<BoxShadow> get elevationLow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevationMedium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get elevationHigh => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // Modern Typography Scale
  static const displayLarge = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const displayMedium = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.15,
  );

  static const displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.2,
  );

  static const headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.25,
  );

  static const headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.3,
  );

  static const headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.35,
  );

  static const titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.4,
  );

  static const titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.5,
  );

  static const titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.5,
  );

  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.45,
  );

  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static const labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.25,
    height: 1.45,
  );

  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
    height: 1.45,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Animation Durations
  static const durationFast = Duration(milliseconds: 150);
  static const durationMedium = Duration(milliseconds: 250);
  static const durationSlow = Duration(milliseconds: 350);
} 