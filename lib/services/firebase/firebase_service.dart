// ignore_for_file: avoid_redundant_argument_values

import 'package:betaversion/config/env_config.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart';

/// Firebase configuration provider for all supported platforms.
///
/// Loads platform-specific Firebase configuration from environment variables
/// managed by [EnvConfig]. This ensures sensitive Firebase credentials are
/// stored securely in `.env` files and not hardcoded in source control.
class FirebaseConfig {
  // Private constructor to prevent instantiation
  FirebaseConfig._();

  /// Returns the appropriate [FirebaseOptions] for the current platform.
  ///
  /// Supports Android, iOS, and macOS. Throws [UnsupportedError] for web
  /// and other unsupported platforms.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Firebase configuration is not available for web platform.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _android;
      case TargetPlatform.iOS:
        return _ios;
      case TargetPlatform.macOS:
        return _macos;
      default:
        throw UnsupportedError(
          'Firebase configuration is not supported for this platform.',
        );
    }
  }

  /// Firebase configuration for Android platform.
  static FirebaseOptions get _android => FirebaseOptions(
    apiKey: EnvConfig.firebaseAndroidApiKey,
    appId: EnvConfig.firebaseAndroidAppId,
    messagingSenderId: EnvConfig.firebaseMessagingSenderId,
    projectId: EnvConfig.firebaseProjectId,
    storageBucket: EnvConfig.firebaseStorageBucket,
  );

  /// Firebase configuration for iOS platform.
  static FirebaseOptions get _ios => FirebaseOptions(
    apiKey: EnvConfig.firebaseIosApiKey,
    appId: EnvConfig.firebaseIosAppId,
    messagingSenderId: EnvConfig.firebaseMessagingSenderId,
    projectId: EnvConfig.firebaseProjectId,
    storageBucket: EnvConfig.firebaseStorageBucket,
    iosBundleId: EnvConfig.firebaseIosBundleId,
    iosClientId: EnvConfig.firebaseIosClientId,
    androidClientId: EnvConfig.firebaseAndroidClientId,
  );

  /// Firebase configuration for macOS platform.
  static FirebaseOptions get _macos => FirebaseOptions(
    apiKey: EnvConfig.firebaseIosApiKey,
    appId: EnvConfig.firebaseIosAppId,
    messagingSenderId: EnvConfig.firebaseMessagingSenderId,
    projectId: EnvConfig.firebaseProjectId,
    storageBucket: EnvConfig.firebaseStorageBucket,
    iosBundleId: EnvConfig.firebaseIosBundleId,
    iosClientId: EnvConfig.firebaseIosClientId,
    androidClientId: EnvConfig.firebaseAndroidClientId,
  );
}

/// Service class for managing Firebase initialization and configuration.
///
/// This service provides a centralized way to initialize Firebase with
/// platform-specific options and handle initialization errors gracefully.
class FirebaseService {
  // Private constructor to prevent instantiation
  FirebaseService._();

  /// Initializes Firebase with platform-specific options.
  ///
  /// Returns `true` if initialization succeeds, `false` otherwise.
  /// Handles [PlatformException] for missing configuration and other exceptions.
  ///
  /// Example:
  /// ```dart
  /// final success = await FirebaseService.initialize();
  /// if (success) {
  ///   // Firebase is ready to use
  /// }
  /// ```
  static Future<bool> initialize() async {
    try {
      await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
      AppLogger.i('🔥 Firebase initialized successfully');
      return true;
    } on PlatformException catch (e, stackTrace) {
      AppLogger.w(
        '⚠️ Firebase initialization skipped (configuration missing)',
        e,
        stackTrace,
      );
    } catch (e, stackTrace) {
      AppLogger.w('⚠️ Firebase initialization failed', e, stackTrace);
    }

    return false;
  }

  /// Checks if Firebase has been initialized.
  static bool get isInitialized {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }
}
