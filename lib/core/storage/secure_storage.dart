import 'dart:developer';

import 'package:betaversion/config/app_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralized secure storage management
class SecureStorage {
  // Private constructor
  SecureStorage._();

  // Singleton instance
  static final SecureStorage _instance = SecureStorage._();
  static SecureStorage get instance => _instance;

  static late FlutterSecureStorage _storage;

  /// Initialize secure storage with environment-specific options
  static Future<void> initialize() async {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  // Storage keys with environment prefix
  static String _getKey(String key) => '${AppConfig.storagePrefix}$key';

  // Common storage keys
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _onboardingCompletedKey = 'onboarding_completed';

  // Authentication methods

  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _getKey(_authTokenKey), value: token);
  }

  static Future<String?> getAuthToken() async {
    return _storage.read(key: _getKey(_authTokenKey));
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _getKey(_refreshTokenKey), value: token);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: _getKey(_refreshTokenKey));
  }

  static Future<void> clearAuthTokens() async {
    await _storage.delete(key: _getKey(_authTokenKey));
    await _storage.delete(key: _getKey(_refreshTokenKey));
  }

  // User data methods
  static Future<void> saveUserId(String userId) async {
    await _storage.write(key: _getKey(_userIdKey), value: userId);
  }

  static Future<String?> getUserId() async {
    return _storage.read(key: _getKey(_userIdKey));
  }

  static Future<void> saveUserPreferences(String preferences) async {
    await _storage.write(key: _getKey(_userPreferencesKey), value: preferences);
  }

  static Future<String?> getUserPreferences() async {
    return _storage.read(key: _getKey(_userPreferencesKey));
  }

  // App settings methods
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _getKey(_biometricEnabledKey),
      value: enabled.toString(),
    );
  }

  static Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _getKey(_biometricEnabledKey));
    return value?.toLowerCase() == 'true';
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    await _storage.write(
      key: _getKey(_onboardingCompletedKey),
      value: completed.toString(),
    );
  }

  static Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _getKey(_onboardingCompletedKey));
    return value?.toLowerCase() == 'true';
  }

  // Generic methods
  static Future<void> setString(String key, String value) async {
    await _storage.write(key: _getKey(key), value: value);
  }

  static Future<String?> getString(String key) async {
    return _storage.read(key: _getKey(key));
  }

  static Future<void> setBool(String key, bool value) async {
    await _storage.write(key: _getKey(key), value: value.toString());
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final value = await _storage.read(key: _getKey(key));
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }

  static Future<void> setInt(String key, int value) async {
    await _storage.write(key: _getKey(key), value: value.toString());
  }

  static Future<int?> getInt(String key) async {
    final value = await _storage.read(key: _getKey(key));
    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> remove(String key) async {
    await _storage.delete(key: _getKey(key));
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Clear all data across all environments (complete reset)
  static Future<void> clearAllEnvironments() async {
    final allKeys = await _storage.readAll();
    final betaversionKeys = allKeys.keys.where(
      (key) => key.contains('_betaversion_'),
    );

    for (final key in betaversionKeys) {
      await _storage.delete(key: key);
    }
  }

  // Utility methods
  static Future<Map<String, String>> getAllKeys() async {
    return _storage.readAll();
  }

  static Future<bool> containsKey(String key) async {
    return _storage.containsKey(key: _getKey(key));
  }

  // Development/debugging methods (only in non-production)
  static Future<void> printAllKeys() async {
    if (!AppConfig.enableLogging) return;

    final allKeys = await getAllKeys();
    log('🔐 Secure Storage Contents:');
    for (final entry in allKeys.entries) {
      // Don't print sensitive values in production
      final maskedValue = entry.key.contains('token')
          ? '***masked***'
          : entry.value;
      log('   ${entry.key}: $maskedValue');
    }
  }
}
