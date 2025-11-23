import 'dart:io';

import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles notification permissions across different platforms.
///
/// Responsible for:
/// - Requesting notification permissions
/// - Checking permission status
/// - Platform-specific permission handling
class NotificationPermissions {
  // Private constructor
  NotificationPermissions._();

  /// Singleton instance
  static final NotificationPermissions _instance = NotificationPermissions._();

  /// Access the singleton instance
  static NotificationPermissions get instance => _instance;

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  /// Requests notification permissions based on platform.
  ///
  /// - iOS: Requests alert, badge, and sound permissions
  /// - macOS: Requests alert, badge, and sound permissions
  /// - Android: Requests notification permission (Android 13+)
  ///
  /// Returns `true` if permissions were granted, `false` otherwise.
  Future<bool> request(FlutterLocalNotificationsPlugin plugin) async {
    try {
      if (Platform.isIOS) {
        return await _requestIOS(plugin);
      } else if (Platform.isMacOS) {
        return await _requestMacOS(plugin);
      } else if (Platform.isAndroid) {
        return await _requestAndroid(plugin);
      }

      AppLogger.w('⚠️ Unsupported platform for notification permissions');
      return false;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error requesting permissions', e, stackTrace);
      return false;
    }
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  /// Requests iOS notification permissions.
  Future<bool> _requestIOS(FlutterLocalNotificationsPlugin plugin) async {
    final bool? granted = await plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    AppLogger.i('📱 iOS notification permissions granted: $granted');
    return granted ?? false;
  }

  /// Requests macOS notification permissions.
  Future<bool> _requestMacOS(FlutterLocalNotificationsPlugin plugin) async {
    final bool? granted = await plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    AppLogger.i('💻 macOS notification permissions granted: $granted');
    return granted ?? false;
  }

  /// Requests Android notification permissions (Android 13+).
  Future<bool> _requestAndroid(FlutterLocalNotificationsPlugin plugin) async {
    final bool? granted = await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    AppLogger.i('🤖 Android notification permissions granted: $granted');
    return granted ?? false;
  }
}
