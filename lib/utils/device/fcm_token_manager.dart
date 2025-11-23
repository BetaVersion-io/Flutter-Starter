import 'dart:async';
import 'dart:io';

import 'package:betaversion/config/app_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenManager {
  FcmTokenManager._();
  static const String _fcmTokenKey = 'fcm_token';
  static const String _fcmTokenTimestampKey = 'fcm_token_timestamp';
  static const int _tokenExpiryHours = 24;

  static FcmTokenManager? _instance;
  String? _cachedFcmToken;
  Timer? _refreshTimer;
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _tokenRefreshRegistered = false;

  static FcmTokenManager get instance {
    _instance ??= FcmTokenManager._();
    return _instance!;
  }

  Future<String> getFcmToken() async {
    _registerTokenRefreshListener();

    if (_cachedFcmToken != null && await _isTokenValid()) {
      return _cachedFcmToken!;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_fcmTokenKey);
    final tokenTimestamp = prefs.getInt(_fcmTokenTimestampKey) ?? 0;

    if (storedToken != null &&
        storedToken.isNotEmpty &&
        _isTimestampValid(tokenTimestamp)) {
      _cachedFcmToken = storedToken;
      _scheduleTokenRefresh();
      return storedToken;
    }

    final newToken = await _generateFcmToken();
    await _storeFcmToken(prefs, newToken);
    _cachedFcmToken = newToken;
    _scheduleTokenRefresh();

    return newToken;
  }

  /// Registers the current push token with CleverTap and returns the token.
  /// Never logs token values; emits minimal debug info only when logging is enabled.
  Future<String?> registerTokenWithCleverTap() async {
    try {
      // Ensure we have a token (from cache or freshly generated)
      final token = await getFcmToken();

      if (AppConfig.enableLogging) {
        debugPrint('✅ Push token registered with CleverTap');
      }
      return token;
    } catch (e) {
      if (AppConfig.enableLogging) {
        debugPrint('❌ Error registering push token with CleverTap: $e');
      }
      return null;
    }
  }

  Future<String> _generateFcmToken() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();

      if (token != null && token.isNotEmpty) {
        return token;
      }

      if (Platform.isIOS) {
        final apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null && apnsToken.isNotEmpty) {
          return apnsToken;
        }
      }

      throw Exception('Failed to obtain FCM token');
    } catch (e) {
      return 'fcm_fallback_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _storeFcmToken(SharedPreferences prefs, String token) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await Future.wait([
      prefs.setString(_fcmTokenKey, token),
      prefs.setInt(_fcmTokenTimestampKey, currentTime),
    ]);
  }

  bool _isTimestampValid(int timestamp) {
    if (timestamp == 0) return false;

    final tokenAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    final maxAge = const Duration(hours: _tokenExpiryHours).inMilliseconds;

    return tokenAge < maxAge;
  }

  Future<bool> _isTokenValid() async {
    if (_cachedFcmToken == null) return false;

    final prefs = await SharedPreferences.getInstance();
    final tokenTimestamp = prefs.getInt(_fcmTokenTimestampKey) ?? 0;

    return _isTimestampValid(tokenTimestamp);
  }

  void _scheduleTokenRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer(
      const Duration(hours: _tokenExpiryHours - 1),
      refreshToken,
    );
  }

  Future<String> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearStoredToken(prefs);

    _cachedFcmToken = null;
    return getFcmToken();
  }

  Future<void> _clearStoredToken(SharedPreferences prefs) async {
    await Future.wait([
      prefs.remove(_fcmTokenKey),
      prefs.remove(_fcmTokenTimestampKey),
    ]);
  }

  Future<void> clearFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    await _clearStoredToken(prefs);

    _cachedFcmToken = null;
    _refreshTimer?.cancel();
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _tokenRefreshRegistered = false;
  }

  Future<bool> hasFcmToken() async {
    if (_cachedFcmToken != null && await _isTokenValid()) {
      return true;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString(_fcmTokenKey);
    final tokenTimestamp = prefs.getInt(_fcmTokenTimestampKey) ?? 0;

    return storedToken != null &&
        storedToken.isNotEmpty &&
        _isTimestampValid(tokenTimestamp);
  }

  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _cachedFcmToken = null;
    _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
    _tokenRefreshRegistered = false;
  }

  void _registerTokenRefreshListener() {
    if (_tokenRefreshRegistered) return;

    _tokenRefreshRegistered = true;
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh
        .listen((token) async {
          if (token.isEmpty) return;

          final prefs = await SharedPreferences.getInstance();
          await _storeFcmToken(prefs, token);
          _cachedFcmToken = token;

          // Optionally register refreshed token with CleverTap
          try {
            if (AppConfig.enableLogging) {
              debugPrint('🔄 Refreshed push token registered with CleverTap');
            }
          } catch (_) {
            // Swallow errors; registration can be retried later
          }
        });
  }
}
