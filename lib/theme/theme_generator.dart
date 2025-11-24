import 'package:betaversion/theme/dark_theme.dart';
import 'package:betaversion/theme/providers/theme_color_provider.dart';
import 'package:betaversion/theme/theme.dart';
import 'package:flutter/material.dart';

/// Generates light theme with the given primary color
ThemeData generateLightTheme(AppThemeColor themeColor) {
  final primaryColor = themeColor.color;

  return appTheme.copyWith(
    primaryColor: primaryColor,
    colorScheme: appTheme.colorScheme.copyWith(
      primary: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: appTheme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(primaryColor),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: appTheme.outlinedButtonTheme.style?.copyWith(
        foregroundColor: WidgetStatePropertyAll(primaryColor),
        side: WidgetStatePropertyAll(BorderSide(color: primaryColor)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: appTheme.textButtonTheme.style?.copyWith(
        foregroundColor: WidgetStatePropertyAll(primaryColor),
      ),
    ),
    inputDecorationTheme: appTheme.inputDecorationTheme.copyWith(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    chipTheme: appTheme.chipTheme.copyWith(
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
    ),
    progressIndicatorTheme: appTheme.progressIndicatorTheme.copyWith(
      color: primaryColor,
    ),
    floatingActionButtonTheme: appTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: primaryColor,
    ),
    bottomNavigationBarTheme: appTheme.bottomNavigationBarTheme.copyWith(
      selectedItemColor: primaryColor,
    ),
    tabBarTheme: appTheme.tabBarTheme.copyWith(
      labelColor: primaryColor,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );
}

/// Generates dark theme with the given primary color
ThemeData generateDarkTheme(AppThemeColor themeColor) {
  final primaryColor = themeColor.lightVariant;
  final isNeutral = themeColor == AppThemeColor.neutral;

  return darkAppTheme.copyWith(
    primaryColor: primaryColor,
    colorScheme: darkAppTheme.colorScheme.copyWith(
      primary: primaryColor,
      onPrimary: isNeutral ? Colors.black : null,
      primaryContainer: primaryColor.withAlpha(51),
      onPrimaryContainer: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: darkAppTheme.elevatedButtonTheme.style?.copyWith(
        backgroundColor: WidgetStatePropertyAll(primaryColor),
        foregroundColor: isNeutral ? const WidgetStatePropertyAll(Colors.black) : null,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: darkAppTheme.outlinedButtonTheme.style?.copyWith(
        foregroundColor: WidgetStatePropertyAll(primaryColor),
        side: WidgetStatePropertyAll(BorderSide(color: primaryColor)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: darkAppTheme.textButtonTheme.style?.copyWith(
        foregroundColor: WidgetStatePropertyAll(primaryColor),
      ),
    ),
    inputDecorationTheme: darkAppTheme.inputDecorationTheme.copyWith(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
    chipTheme: darkAppTheme.chipTheme.copyWith(
      selectedColor: primaryColor,
      secondarySelectedColor: primaryColor,
    ),
    progressIndicatorTheme: darkAppTheme.progressIndicatorTheme.copyWith(
      color: primaryColor,
    ),
    floatingActionButtonTheme: darkAppTheme.floatingActionButtonTheme.copyWith(
      backgroundColor: primaryColor,
      foregroundColor: isNeutral ? Colors.black : null,
    ),
    bottomNavigationBarTheme: darkAppTheme.bottomNavigationBarTheme.copyWith(
      selectedItemColor: primaryColor,
    ),
    tabBarTheme: darkAppTheme.tabBarTheme.copyWith(
      labelColor: primaryColor,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    ),
  );
}
