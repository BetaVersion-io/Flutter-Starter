import 'dart:developer';

import 'package:betaversion/config/env_config.dart';
import 'package:flutter/foundation.dart';

/// Application-wide configuration that combines environment variables
/// with build-time constants and runtime settings
class AppConfig {
  // Private constructor
  AppConfig._();

  // Singleton instance
  static final AppConfig _instance = AppConfig._();
  static AppConfig get instance => _instance;

  // App Information
  static String get appName => EnvConfig.appName;

  // Build Configuration
  static bool get isDebugBuild => kDebugMode;
  static bool get isReleaseBuild => kReleaseMode;
  static bool get isProfileBuild => kProfileMode;

  // Environment-based Configuration
  static bool get enableCrashReporting => EnvConfig.isProduction;
  static bool get enableAnalytics => !EnvConfig.isDevelopment;
  static bool get enablePerformanceMonitoring => EnvConfig.isProduction;

  // API Configuration
  static Duration get apiTimeout => Duration(seconds: EnvConfig.timeoutSeconds);
  static int get maxRetryAttempts => EnvConfig.maxRetryAttempts;

  // UI Configuration
  static bool get showDebugInfo => EnvConfig.isDebugMode && kDebugMode;
  static bool get enableDevTools => EnvConfig.isDevelopment;

  // Feature Flags
  static bool get isNewUiEnabled => EnvConfig.isNewUiEnabled;
  static bool get isPremiumEnabled => EnvConfig.isPremiumEnabled;
  static bool get enableBetaFeatures =>
      EnvConfig.isDevelopment || EnvConfig.isStaging;

  // Cache Configuration
  static Duration get cacheExpiry => EnvConfig.isProduction
      ? const Duration(hours: 24)
      : const Duration(minutes: 5);

  // Storage Configuration
  static String get storagePrefix => '${EnvConfig.currentEnv}_betaversion_';

  // Logging Configuration
  static bool get enableLogging => EnvConfig.enableLogging;
  static String get logLevel => EnvConfig.logLevel;

  // Security Configuration
  static bool get enableCertificatePinning => EnvConfig.isProduction;
  static bool get requireBiometrics => EnvConfig.isProduction;

  // Development Tools
  static bool get enableMockData => EnvConfig.isDevelopment;
  static bool get enableTestMode =>
      EnvConfig.isDevelopment || EnvConfig.isStaging;

  /// Initialize app configuration
  static Future<void> initialize() async {
    // Validate configuration
    EnvConfig.validateConfig();

    // Print debug info in non-production environments
    if (showDebugInfo) {
      EnvConfig.printLoadedEnv();
      printAppConfig();
    }
  }

  /// Print app configuration (debug only)
  static void printAppConfig() {
    if (!EnvConfig.isProduction) {
      log('⚙️ App Configuration:');
      log(
        '   🏗️ Build: ${isDebugBuild
            ? 'Debug'
            : isReleaseBuild
            ? 'Release'
            : 'Profile'}',
      );
      log('   🎯 Features: newUI=$isNewUiEnabled, premium=$isPremiumEnabled');
      log(
        '   🔧 Tools: crashReporting=$enableCrashReporting, analytics=$enableAnalytics',
      );
      log(
        '   ⏱️ Timeout: ${apiTimeout.inSeconds}s, Retries: $maxRetryAttempts',
      );
    }
  }
}
