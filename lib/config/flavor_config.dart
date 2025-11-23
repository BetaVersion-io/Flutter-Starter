import 'dart:developer';

class FlavorConfig {
  static const String _flavorKey = 'FLAVOR';
  static const String _environmentKey = 'ENVIRONMENT';

  // Available flavors
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';

  /// Get current flavor from build arguments
  static String get currentFlavor {
    return const String.fromEnvironment(_flavorKey, defaultValue: development);
  }

  /// Get current environment from build arguments
  static String get currentEnvironment {
    return const String.fromEnvironment(
      _environmentKey,
      defaultValue: development,
    );
  }

  /// Check if we're in development flavor
  static bool get isDevelopment => currentFlavor == development;

  /// Check if we're in staging flavor
  static bool get isStaging => currentFlavor == staging;

  /// Check if we're in production flavor
  static bool get isProduction => currentFlavor == production;

  /// Get flavor-specific app name
  static String get appName {
    switch (currentFlavor) {
      case development:
        return 'BetaVersion Dev';
      case staging:
        return 'BetaVersion Staging';
      case production:
        return 'BetaVersion';
      default:
        return 'BetaVersion';
    }
  }

  /// Get flavor-specific package name/bundle ID
  static String get packageName {
    switch (currentFlavor) {
      case development:
        return 'com.betaversion.dev';
      case staging:
        return 'com.betaversion.staging';
      case production:
        return 'com.betaversion.io';
      default:
        return 'com.betaversion.io';
    }
  }

  /// Debug information
  static void printFlavorInfo() {
    if (!isProduction) {
      log('🎯 Current Flavor: $currentFlavor');
      log('🌍 Environment: $currentEnvironment');
      log('📱 App Name: $appName');
      log('📦 Package: $packageName');
    }
  }
}
