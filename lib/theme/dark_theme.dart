import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:betaversion/theme/extensions/box_shadow_extension.dart';
import 'package:flutter/material.dart';

const _backgroundColor = Color.fromARGB(255, 0, 0, 0);
const _paperColor = Color.fromARGB(255, 21, 22, 22);

final ThemeData darkAppTheme = ThemeData(
  useMaterial3: true,

  fontFamily: 'Poppins',
  brightness: Brightness.dark,
  primaryColor: const Color.fromARGB(255, 255, 255, 255),
  scaffoldBackgroundColor: _backgroundColor,
  dividerColor: const Color.fromARGB(255, 48, 48, 48),
  shadowColor: AppColors.grey950,
  cardColor: _paperColor,

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.brand500,
    onPrimary: Colors.white,
    secondary: AppColors.midNightBlue400,
    onSecondary: Colors.white,
    error: AppColors.error500,
    onError: Colors.white,
    surface: AppColors.grey900,
    onSurface: Colors.white,
    onTertiary: Color(0xB3FFFFFF),
    inverseSurface: AppColors.grey100,
  ),

  // Theme Extensions
  extensions: <ThemeExtension<dynamic>>[darkBoxShadows],

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
  ).apply(bodyColor: Colors.white, displayColor: Colors.white),

  appBarTheme: AppBarTheme(
    backgroundColor: _backgroundColor,
    foregroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.transparent, // Disable surface tint
    scrolledUnderElevation: 0, // Prevent elevation change on scroll
    centerTitle: false,
    titleTextStyle: AppTypography.heading5.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: AppColors.grey50,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brand500,
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
      foregroundColor: AppColors.brand500,
      side: const BorderSide(color: AppColors.brand500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        color: AppColors.brand500,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.brand500,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: AppTypography.bodyLargeBold,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: _backgroundColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.grey700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.brand500, width: 2),
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
      color: AppColors.grey400,
    ),
    hintStyle: AppTypography.bodyMediumRegular.copyWith(
      color: AppColors.grey500,
    ),
  ),

  cardTheme: CardThemeData(
    color: _paperColor,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.zero,
  ),

  dividerTheme: const DividerThemeData(
    color: AppColors.grey700,
    thickness: 1,
    space: 1,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: AppColors.grey800,
    disabledColor: AppColors.grey700,
    selectedColor: AppColors.brand500,
    secondarySelectedColor: AppColors.brand500,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    labelStyle: AppTypography.bodySmallMedium.copyWith(color: Colors.white),
    secondaryLabelStyle: AppTypography.bodySmallMedium.copyWith(
      color: Colors.white,
    ),
    brightness: Brightness.dark,
  ),

  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.brand500,
    linearTrackColor: AppColors.grey700,
    circularTrackColor: AppColors.grey700,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.brand500,
    foregroundColor: Colors.white,
    elevation: 2,
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.grey900,
    selectedItemColor: AppColors.brand500,
    unselectedItemColor: AppColors.grey500,
    elevation: 0,
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.grey900,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    titleTextStyle: AppTypography.heading6.copyWith(color: Colors.white),
    contentTextStyle: AppTypography.bodyMediumRegular.copyWith(
      color: Colors.white,
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.white,
    contentTextStyle: AppTypography.bodyMediumRegular.copyWith(
      color: AppColors.grey900,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
  ),

  tabBarTheme: const TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: AppColors.brand500,
    unselectedLabelColor: AppColors.grey500,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.brand500, width: 2),
    ),
  ),
);
