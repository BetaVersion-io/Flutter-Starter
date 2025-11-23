import 'dart:developer';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  EnvConfig._();

  static bool _initialized = false;

  // Environment types
  static const String development = 'development';
  static const String staging = 'staging';
  static const String production = 'production';

  static String _currentEnv = development;
  static String get currentEnv => _currentEnv;

  // Web compile-time constants (only these 3 come from .env)
  static const _webAppName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'BetaVersion',
  );
  static const _webApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );
  static const _webApiVersion = String.fromEnvironment(
    'API_VERSION',
    defaultValue: 'v1',
  );

  /// Initialize environment
  static Future<void> initialize([String env = development]) async {
    _currentEnv = env;
    if (_initialized || kIsWeb) return;

    final envFile = switch (env) {
      staging => '.env.staging',
      production => '.env.production',
      _ => '.env',
    };

    try {
      await dotenv.load(fileName: envFile);
      _initialized = true;
    } catch (e) {
      log('Failed to load $envFile: $e');
    }
  }

  // Helper to get env value
  static String _get(String key, String webValue, String defaultValue) {
    if (kIsWeb) return webValue.isEmpty ? defaultValue : webValue;
    if (!_initialized) return defaultValue;
    return dotenv.env[key] ?? defaultValue;
  }

  // Helper for Firebase config (no web support needed)
  static String _getEnv(String key, [String defaultValue = '']) {
    if (!_initialized) return defaultValue;
    return dotenv.env[key] ?? defaultValue;
  }

  // === Environment Helpers ===
  static bool get isDevelopment => _currentEnv == development;
  static bool get isStaging => _currentEnv == staging;
  static bool get isProduction => _currentEnv == production;
  static bool get isDebugMode => isDevelopment || isStaging;

  // === Environment Variables (from .env) ===
  static String get appName => _get('APP_NAME', _webAppName, 'BetaVersion');
  static String get apiBaseUrl =>
      _get('API_BASE_URL', _webApiBaseUrl, 'https://api.example.com');
  static String get apiVersion => _get('API_VERSION', _webApiVersion, 'v1');
  static String get fullApiUrl => '$apiBaseUrl/$apiVersion';

  // === Firebase Configuration (from .env) ===
  static String get firebaseProjectId => _getEnv('FIREBASE_PROJECT_ID');
  static String get firebaseStorageBucket => _getEnv('FIREBASE_STORAGE_BUCKET');
  static String get firebaseMessagingSenderId => _getEnv('FIREBASE_MESSAGING_SENDER_ID');
  static String get firebaseAndroidApiKey => _getEnv('FIREBASE_ANDROID_API_KEY');
  static String get firebaseAndroidAppId => _getEnv('FIREBASE_ANDROID_APP_ID');
  static String get firebaseIosApiKey => _getEnv('FIREBASE_IOS_API_KEY');
  static String get firebaseIosAppId => _getEnv('FIREBASE_IOS_APP_ID');
  static String get firebaseIosBundleId => _getEnv('FIREBASE_IOS_BUNDLE_ID');
  static String get firebaseIosClientId => _getEnv('FIREBASE_IOS_CLIENT_ID');
  static String get firebaseAndroidClientId => _getEnv('FIREBASE_ANDROID_CLIENT_ID');

  // === App Constants (not from .env, just config) ===
  static int get timeoutSeconds => 30;
  static int get maxRetryAttempts => 3;
  static bool get enableLogging => !isProduction;
  static String get logLevel => isProduction ? 'error' : 'debug';
  static bool get isNewUiEnabled => false;
  static bool get isPremiumEnabled => false;

  static bool validateConfig() {
    if (apiBaseUrl.isEmpty || apiVersion.isEmpty) {
      throw Exception('Missing required config: API_BASE_URL or API_VERSION');
    }
    return true;
  }

  static void printLoadedEnv() {
    if (!isProduction) {
      log('Environment: $_currentEnv');
      log('App Name: $appName');
      log('API URL: $fullApiUrl');
    }
  }
}
