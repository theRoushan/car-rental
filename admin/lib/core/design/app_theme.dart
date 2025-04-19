import 'package:flutter/material.dart';
import 'design_tokens.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: DesignTokens.primary,
        onPrimary: Colors.white,
        primaryContainer: DesignTokens.primaryLight,
        onPrimaryContainer: DesignTokens.primaryDark,
        secondary: DesignTokens.secondary,
        onSecondary: Colors.white,
        secondaryContainer: DesignTokens.secondaryLight,
        onSecondaryContainer: DesignTokens.secondaryDark,
        error: DesignTokens.error,
        onError: Colors.white,
        surface: DesignTokens.lightSurface,
        onSurface: DesignTokens.lightText,
        surfaceContainerHighest: DesignTokens.lightBackground,
        onSurfaceVariant: DesignTokens.lightTextSecondary,
      ),
      scaffoldBackgroundColor: DesignTokens.lightBackground,
      textTheme: const TextTheme(
        displayLarge: DesignTokens.displayLarge,
        displayMedium: DesignTokens.displayMedium,
        displaySmall: DesignTokens.displaySmall,
        headlineLarge: DesignTokens.headlineLarge,
        headlineMedium: DesignTokens.headlineMedium,
        headlineSmall: DesignTokens.headlineSmall,
        titleLarge: DesignTokens.titleLarge,
        titleMedium: DesignTokens.titleMedium,
        titleSmall: DesignTokens.titleSmall,
        labelLarge: DesignTokens.labelLarge,
        labelMedium: DesignTokens.labelMedium,
        labelSmall: DesignTokens.labelSmall,
        bodyLarge: DesignTokens.bodyLarge,
        bodyMedium: DesignTokens.bodyMedium,
        bodySmall: DesignTokens.bodySmall,
      ).apply(
        bodyColor: DesignTokens.lightText,
        displayColor: DesignTokens.lightText,
      ),
      cardTheme: CardTheme(
        color: DesignTokens.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.lightSurface,
        foregroundColor: DesignTokens.lightText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: DesignTokens.titleLarge.copyWith(
          color: DesignTokens.lightText,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.lightSurface,
        selectedItemColor: DesignTokens.primary,
        unselectedItemColor: DesignTokens.lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),
      dividerTheme: const DividerThemeData(
        color: DesignTokens.lightDivider,
        space: DesignTokens.spaceMD,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLG,
            vertical: DesignTokens.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          textStyle: DesignTokens.labelLarge,
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.white,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) return 0;
              if (states.contains(WidgetState.hovered)) return 2;
              return 0;
            },
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLG,
            vertical: DesignTokens.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          side: const BorderSide(color: DesignTokens.primary),
          textStyle: DesignTokens.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceSM,
          ),
          textStyle: DesignTokens.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.lightBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.error, width: 2),
        ),
        contentPadding: const EdgeInsets.all(DesignTokens.spaceMD),
        labelStyle: DesignTokens.bodyMedium,
        hintStyle: DesignTokens.bodyMedium.copyWith(
          color: DesignTokens.lightTextSecondary,
        ),
        errorStyle: DesignTokens.labelMedium.copyWith(
          color: DesignTokens.error,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DesignTokens.primary.withOpacity(0.1),
        selectedColor: DesignTokens.primary,
        labelStyle: DesignTokens.labelMedium.copyWith(
          color: DesignTokens.primary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceSM,
          vertical: DesignTokens.spaceXXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DesignTokens.lightText,
        contentTextStyle: DesignTokens.bodyMedium.copyWith(
          color: DesignTokens.lightSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: DesignTokens.primary,
        onPrimary: Colors.white,
        primaryContainer: DesignTokens.primaryDark,
        onPrimaryContainer: DesignTokens.primaryLight,
        secondary: DesignTokens.secondary,
        onSecondary: Colors.white,
        secondaryContainer: DesignTokens.secondaryDark,
        onSecondaryContainer: DesignTokens.secondaryLight,
        error: DesignTokens.error,
        onError: Colors.white,
        surface: DesignTokens.darkSurface,
        onSurface: DesignTokens.darkText,
        surfaceContainerHighest: DesignTokens.darkBackground,
        onSurfaceVariant: DesignTokens.darkTextSecondary,
      ),
      scaffoldBackgroundColor: DesignTokens.darkBackground,
      textTheme: const TextTheme(
        displayLarge: DesignTokens.displayLarge,
        displayMedium: DesignTokens.displayMedium,
        displaySmall: DesignTokens.displaySmall,
        headlineLarge: DesignTokens.headlineLarge,
        headlineMedium: DesignTokens.headlineMedium,
        headlineSmall: DesignTokens.headlineSmall,
        titleLarge: DesignTokens.titleLarge,
        titleMedium: DesignTokens.titleMedium,
        titleSmall: DesignTokens.titleSmall,
        labelLarge: DesignTokens.labelLarge,
        labelMedium: DesignTokens.labelMedium,
        labelSmall: DesignTokens.labelSmall,
        bodyLarge: DesignTokens.bodyLarge,
        bodyMedium: DesignTokens.bodyMedium,
        bodySmall: DesignTokens.bodySmall,
      ).apply(
        bodyColor: DesignTokens.darkText,
        displayColor: DesignTokens.darkText,
      ),
      cardTheme: CardTheme(
        color: DesignTokens.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.darkSurface,
        foregroundColor: DesignTokens.darkText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: DesignTokens.titleLarge.copyWith(
          color: DesignTokens.darkText,
        ),
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.darkSurface,
        selectedItemColor: DesignTokens.primary,
        unselectedItemColor: DesignTokens.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),
      dividerTheme: const DividerThemeData(
        color: DesignTokens.darkDivider,
        space: DesignTokens.spaceMD,
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLG,
            vertical: DesignTokens.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          textStyle: DesignTokens.labelLarge,
          backgroundColor: DesignTokens.primary,
          foregroundColor: Colors.white,
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) return 0;
              if (states.contains(WidgetState.hovered)) return 2;
              return 0;
            },
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLG,
            vertical: DesignTokens.spaceMD,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          side: const BorderSide(color: DesignTokens.primary),
          textStyle: DesignTokens.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceSM,
          ),
          textStyle: DesignTokens.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.darkBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(color: DesignTokens.error, width: 2),
        ),
        contentPadding: const EdgeInsets.all(DesignTokens.spaceMD),
        labelStyle: DesignTokens.bodyMedium,
        hintStyle: DesignTokens.bodyMedium.copyWith(
          color: DesignTokens.darkTextSecondary,
        ),
        errorStyle: DesignTokens.labelMedium.copyWith(
          color: DesignTokens.error,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: DesignTokens.primary.withOpacity(0.2),
        selectedColor: DesignTokens.primary,
        labelStyle: DesignTokens.labelMedium.copyWith(
          color: DesignTokens.primary,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceSM,
          vertical: DesignTokens.spaceXXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCircular),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: DesignTokens.darkText,
        contentTextStyle: DesignTokens.bodyMedium.copyWith(
          color: DesignTokens.darkBackground,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 