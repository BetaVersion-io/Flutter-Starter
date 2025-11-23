import 'package:betaversion/theme/constants/colors.dart';
import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color brand;
  final Color brandLight;
  final Color brandDark;
  final Color error;
  final Color errorLight;
  final Color errorDark;
  final Color secondary;
  final Color secondaryLight;
  final Color secondaryDark;
  final Color secondaryText;
  final Color success;
  final Color successLight;
  final Color successDark;
  final Color warning;
  final Color warningLight;
  final Color warningDark;
  final Color grey50;
  final Color grey100;
  final Color grey200;
  final Color grey300;
  final Color grey400;
  final Color grey500;
  final Color grey600;
  final Color grey700;
  final Color grey800;
  final Color grey900;
  final Color grey950;

  const CustomColors({
    required this.brand,
    required this.brandLight,
    required this.brandDark,
    required this.error,
    required this.errorLight,
    required this.errorDark,
    required this.secondary,
    required this.secondaryLight,
    required this.secondaryDark,
    required this.secondaryText,
    required this.success,
    required this.successLight,
    required this.successDark,
    required this.warning,
    required this.warningLight,
    required this.warningDark,
    required this.grey50,
    required this.grey100,
    required this.grey200,
    required this.grey300,
    required this.grey400,
    required this.grey500,
    required this.grey600,
    required this.grey700,
    required this.grey800,
    required this.grey900,
    required this.grey950,
  });

  @override
  CustomColors copyWith({
    Color? brand,
    Color? brandLight,
    Color? brandDark,
    Color? error,
    Color? errorLight,
    Color? errorDark,
    Color? secondary,
    Color? secondaryLight,
    Color? secondaryDark,
    Color? secondaryText,
    Color? success,
    Color? successLight,
    Color? successDark,
    Color? warning,
    Color? warningLight,
    Color? warningDark,
    Color? grey50,
    Color? grey100,
    Color? grey200,
    Color? grey300,
    Color? grey400,
    Color? grey500,
    Color? grey600,
    Color? grey700,
    Color? grey800,
    Color? grey900,
    Color? grey950,
  }) {
    return CustomColors(
      brand: brand ?? this.brand,
      brandLight: brandLight ?? this.brandLight,
      brandDark: brandDark ?? this.brandDark,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      errorDark: errorDark ?? this.errorDark,
      secondary: secondary ?? this.secondary,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      secondaryText: secondaryText ?? this.secondaryText,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      successDark: successDark ?? this.successDark,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      warningDark: warningDark ?? this.warningDark,
      grey50: grey50 ?? this.grey50,
      grey100: grey100 ?? this.grey100,
      grey200: grey200 ?? this.grey200,
      grey300: grey300 ?? this.grey300,
      grey400: grey400 ?? this.grey400,
      grey500: grey500 ?? this.grey500,
      grey600: grey600 ?? this.grey600,
      grey700: grey700 ?? this.grey700,
      grey800: grey800 ?? this.grey800,
      grey900: grey900 ?? this.grey900,
      grey950: grey950 ?? this.grey950,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      brand: Color.lerp(brand, other.brand, t) ?? brand,
      brandLight: Color.lerp(brandLight, other.brandLight, t) ?? brandLight,
      brandDark: Color.lerp(brandDark, other.brandDark, t) ?? brandDark,
      error: Color.lerp(error, other.error, t) ?? error,
      errorLight: Color.lerp(errorLight, other.errorLight, t) ?? errorLight,
      errorDark: Color.lerp(errorDark, other.errorDark, t) ?? errorDark,
      secondary: Color.lerp(secondary, other.secondary, t) ?? secondary,
      secondaryLight:
          Color.lerp(secondaryLight, other.secondaryLight, t) ?? secondaryLight,
      secondaryDark:
          Color.lerp(secondaryDark, other.secondaryDark, t) ?? secondaryDark,
      secondaryText:
          Color.lerp(secondaryText, other.secondaryText, t) ?? secondaryText,
      success: Color.lerp(success, other.success, t) ?? success,
      successLight:
          Color.lerp(successLight, other.successLight, t) ?? successLight,
      successDark: Color.lerp(successDark, other.successDark, t) ?? successDark,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      warningLight:
          Color.lerp(warningLight, other.warningLight, t) ?? warningLight,
      warningDark: Color.lerp(warningDark, other.warningDark, t) ?? warningDark,
      grey50: Color.lerp(grey50, other.grey50, t) ?? grey50,
      grey100: Color.lerp(grey100, other.grey100, t) ?? grey100,
      grey200: Color.lerp(grey200, other.grey200, t) ?? grey200,
      grey300: Color.lerp(grey300, other.grey300, t) ?? grey300,
      grey400: Color.lerp(grey400, other.grey400, t) ?? grey400,
      grey500: Color.lerp(grey500, other.grey500, t) ?? grey500,
      grey600: Color.lerp(grey600, other.grey600, t) ?? grey600,
      grey700: Color.lerp(grey700, other.grey700, t) ?? grey700,
      grey800: Color.lerp(grey800, other.grey800, t) ?? grey800,
      grey900: Color.lerp(grey900, other.grey900, t) ?? grey900,
      grey950: Color.lerp(grey950, other.grey950, t) ?? grey950,
    );
  }

  static const light = CustomColors(
    brand: AppColors.brand950,
    brandLight: AppColors.brand300,
    brandDark: AppColors.brand700,
    error: AppColors.error600,
    errorLight: AppColors.error400,
    errorDark: AppColors.error700,
    secondary: AppColors.midNightBlue500,
    secondaryLight: AppColors.midNightBlue300,
    secondaryDark: AppColors.midNightBlue700,
    secondaryText: AppColors.grey50,
    success: AppColors.success600,
    successLight: AppColors.success300,
    successDark: AppColors.success700,
    warning: AppColors.warning500,
    warningLight: AppColors.warning300,
    warningDark: AppColors.warning700,
    grey50: AppColors.grey50,
    grey100: AppColors.grey100,
    grey200: AppColors.grey200,
    grey300: AppColors.grey300,
    grey400: AppColors.grey400,
    grey500: AppColors.grey500,
    grey600: AppColors.grey600,
    grey700: AppColors.grey700,
    grey800: AppColors.grey800,
    grey900: AppColors.grey900,
    grey950: AppColors.grey950,
  );

  static const dark = CustomColors(
    brand: AppColors.brand500,
    brandLight: AppColors.brand200,
    brandDark: AppColors.brand600,
    error: AppColors.error600,
    errorLight: AppColors.error400,
    errorDark: AppColors.error700,
    secondary: AppColors.midNightBlue500,
    secondaryLight: AppColors.midNightBlue300,
    secondaryDark: AppColors.midNightBlue700,
    secondaryText: AppColors.grey50,
    success: AppColors.success600,
    successLight: AppColors.success400,
    successDark: AppColors.success700,
    warning: AppColors.warning400,
    warningLight: AppColors.warning200,
    warningDark: AppColors.warning600,
    grey50: AppColors.darkGrey50,
    grey100: AppColors.darkGrey100,
    grey200: AppColors.darkGrey200,
    grey300: AppColors.darkGrey300,
    grey400: AppColors.darkGrey400,
    grey500: AppColors.darkGrey500,
    grey600: AppColors.darkGrey600,
    grey700: AppColors.darkGrey700,
    grey800: AppColors.darkGrey800,
    grey900: AppColors.darkGrey900,
    grey950: AppColors.darkGrey950,
  );
}

extension CustomColorsExtension on BuildContext {
  CustomColors get customColors {
    final theme = Theme.of(this);
    final extension = theme.extension<CustomColors>();

    // If extension exists, use it
    if (extension != null) return extension;

    // Fallback: Choose appropriate theme based on current brightness
    return theme.isDark ? CustomColors.dark : CustomColors.light;
  }
}

extension ThemeDataExtensions on ThemeData {
  bool get isDark => brightness == Brightness.dark;
  bool get isLight => brightness == Brightness.light;
}

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  /// Get current theme brightness
  Brightness get brightness => theme.brightness;

  /// Check if current theme is dark
  bool get isDarkTheme => theme.brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLightTheme => theme.brightness == Brightness.light;

  /// Get colors with theme awareness
  ColorScheme get colors => theme.colorScheme;
}

extension ThemeExtensions on ThemeData {
  Color get paperColor {
    final isDark = this.isDark;
    return isDark
        ? const Color.fromARGB(255, 20, 20, 20)
        : const Color.fromARGB(255, 244, 244, 244);
  }

  /// Sheet color for bottom sheets
  /// Dark: same as paperColor
  /// Light: scaffoldBackgroundColor
  Color get sheetColor {
    return isDark
        ? const Color.fromARGB(255, 20, 20, 20)
        : scaffoldBackgroundColor;
  }
}
