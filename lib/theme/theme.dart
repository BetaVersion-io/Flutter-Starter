/// Light Theme Configuration
///
/// This library defines the light theme configuration for the betaversion application.
/// It provides a comprehensive Material 3 theme with consistent colors, typography,
/// and component styles throughout the app.
///
/// The theme includes:
/// - Brand colors and semantic color scheme
/// - Typography system using Poppins font family
/// - Component themes for buttons, inputs, cards, etc.
/// - Consistent spacing and border radius values
/// - Material 3 design guidelines compliance
///
/// The theme uses the app's custom color palette defined in [AppColors]
/// and typography system from [AppTypography] to ensure brand consistency.
///
/// Example usage:
/// ```dart
/// MaterialApp(
///   theme: appTheme,
///   home: MyHomeScreen(),
/// )
/// ```
library;

import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:betaversion/theme/extensions/box_shadow_extension.dart';
import 'package:flutter/material.dart';

/// The main light theme for the betaversion application.
///
/// This theme provides a comprehensive Material 3 design system configuration
/// with the betaversion brand colors, Poppins typography, and consistent component
/// styling. It defines the visual appearance of all UI elements in light mode.
///
/// Key features:
/// - Material 3 compliance with useMaterial3: true
/// - Brand-consistent color scheme using [AppColors]
/// - Poppins font family throughout the app
/// - Rounded corners (8-12px) for modern look
/// - Consistent elevation and shadow treatment
/// - Semantic color mapping for accessibility
///
/// The theme covers all major Flutter components including buttons, inputs,
/// cards, app bars, navigation bars, dialogs, and more.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  fontFamily: 'Poppins',
  primaryColor: AppColors.brand950,
  dividerColor: AppColors.grey50,
  shadowColor: Colors.grey,
  cardColor: Colors.white,
  // Color Scheme
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.brand950,
    onPrimary: Colors.white,
    secondary: AppColors.midNightBlue400,
    onSecondary: Colors.white,
    error: AppColors.error500,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: AppColors.grey900,
    onTertiary: AppColors.grey900.withAlpha(180),
    inverseSurface: Colors.black,
  ),

  // Theme Extensions
  extensions: <ThemeExtension<dynamic>>[lightBoxShadows],

  // Text Theme
  textTheme: const TextTheme(
    displayLarge: AppTypography.heading1,
    displayMedium: AppTypography.heading2,
    displaySmall: AppTypography.heading3,
    headlineMedium: AppTypography.heading4,
    headlineSmall: AppTypography.heading5,
    titleLarge: AppTypography.heading6,
    bodyLarge: AppTypography.bodyLargeRegular,
    bodyMedium: AppTypography.bodyMediumRegular,
    bodySmall: AppTypography.bodySmallRegular,
    labelLarge: AppTypography.bodyLargeMedium,
    labelMedium: AppTypography.bodyMediumMedium,
    labelSmall: AppTypography.bodySmallMedium,
  ).apply(bodyColor: AppColors.grey900, displayColor: AppColors.grey900),

  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.grey900,
    elevation: 0,
    centerTitle: false,
    surfaceTintColor: Colors.transparent, // Disable surface tint
    scrolledUnderElevation: 0, // Prevent elevation change on scroll
    titleTextStyle: AppTypography.heading5.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: AppColors.grey900,
    ),
    iconTheme: const IconThemeData(color: AppColors.grey900),
  ),

  // Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brand950,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.brand950,
      side: const BorderSide(),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        color: AppColors.brand950,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.brand950,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: AppTypography.bodyLargeBold,
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.grey600, // Your desired border color
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error500),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error500, width: 2),
    ),
    labelStyle: AppTypography.bodyMediumRegular.copyWith(
      color: AppColors.grey500,
    ),
    hintStyle: AppTypography.bodyMediumRegular.copyWith(
      color: AppColors.grey400,
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.zero,
  ),

  // Divider Theme
  dividerTheme: const DividerThemeData(
    color: AppColors.grey200,
    thickness: 1,
    space: 1,
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.grey100,
    disabledColor: AppColors.grey200,
    selectedColor: AppColors.brand950,
    secondarySelectedColor: AppColors.brand950,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    labelStyle: AppTypography.bodySmallMedium,
    secondaryLabelStyle: AppTypography.bodySmallMedium.copyWith(
      color: Colors.white,
    ),
    brightness: Brightness.light,
  ),

  // Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.brand950,
    linearTrackColor: AppColors.grey200,
    circularTrackColor: AppColors.grey200,
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.brand950,
    foregroundColor: Colors.white,
    elevation: 2,
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.brand950,
    unselectedItemColor: AppColors.grey400,
    elevation: 0,
  ),

  // Dialog Theme
  dialogTheme: DialogThemeData(
    backgroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    titleTextStyle: AppTypography.heading6,
    contentTextStyle: AppTypography.bodyMediumRegular,
  ),

  // SnackBar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.grey900,
    contentTextStyle: AppTypography.bodyMediumRegular.copyWith(
      color: Colors.white,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
  ),

  // Tab Bar Theme
  tabBarTheme: const TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: AppColors.brand950,
    unselectedLabelColor: AppColors.grey500,
    indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2)),
  ),
);
