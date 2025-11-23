/// Device Security Utilities
///
/// Provides security checks for the device including developer mode detection
library;

import 'dart:io';

import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter/services.dart';

/// Utility class for device security checks
class DeviceSecurityUtils {
  DeviceSecurityUtils._();

  static const _channel = MethodChannel('com.betaversion.app/security');

  /// Check if developer options are enabled on Android
  ///
  /// Returns `true` if developer mode is detected, `false` otherwise
  /// Always returns `false` on iOS and other platforms
  static Future<bool> isDeveloperOptionsEnabled() async {
    try {
      if (!Platform.isAndroid) {
        return false; // iOS doesn't have developer options like Android
      }

      final bool isEnabled = await _channel.invokeMethod(
        'isDeveloperOptionsEnabled',
      );

      if (isEnabled) {
        AppLogger.w('⚠️ [Security] Developer options detected');
      }

      return isEnabled;
    } on PlatformException catch (e) {
      AppLogger.e('❌ [Security] Failed to check developer options', e);
      return false; // Fail safely - don't block app if check fails
    } catch (e) {
      AppLogger.e(
        '❌ [Security] Unexpected error checking developer options',
        e,
      );
      return false;
    }
  }

  /// Open device developer settings
  ///
  /// Opens the developer options screen on Android
  /// Opens the app settings on iOS
  static Future<void> openDeveloperSettings() async {
    try {
      await _channel.invokeMethod('openDeveloperSettings');

      if (Platform.isAndroid) {
        AppLogger.i('🔧 [Security] Opened developer settings');
      } else if (Platform.isIOS) {
        AppLogger.i('🔧 [Security] Opened app settings');
      }
    } on PlatformException catch (e) {
      AppLogger.e('❌ [Security] Failed to open settings', e);
    } catch (e) {
      AppLogger.e('❌ [Security] Unexpected error opening settings', e);
    }
  }

  /// Check if app is running in debug mode
  ///
  /// Returns `true` if running with debugger attached
  static bool isDebugMode() {
    bool isDebug = false;
    assert(() {
      isDebug = true;
      return true;
    }());
    return isDebug;
  }

  /// Check if device is rooted (Android) or jailbroken (iOS)
  ///
  /// Note: This is a basic check and can be bypassed by sophisticated tools
  /// For production apps, consider using dedicated security packages
  static Future<bool> isDeviceCompromised() async {
    try {
      if (Platform.isAndroid) {
        return await _checkAndroidRoot();
      } else if (Platform.isIOS) {
        return await _checkIOSJailbreak();
      }
      return false;
    } catch (e) {
      AppLogger.e('❌ [Security] Error checking device compromise', e);
      return false;
    }
  }

  static Future<bool> _checkAndroidRoot() async {
    try {
      final bool isRooted = await _channel.invokeMethod('isDeviceRooted');
      if (isRooted) {
        AppLogger.w('⚠️ [Security] Rooted device detected');
      }
      return isRooted;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> _checkIOSJailbreak() async {
    try {
      final bool isJailbroken = await _channel.invokeMethod(
        'isDeviceJailbroken',
      );
      if (isJailbroken) {
        AppLogger.w('⚠️ [Security] Jailbroken device detected');
      }
      return isJailbroken;
    } catch (e) {
      return false;
    }
  }
}
