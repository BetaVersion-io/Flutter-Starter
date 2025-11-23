import 'package:betaversion/services/notification/notification_config.dart';
import 'package:betaversion/services/notification/notification_display.dart';
import 'package:betaversion/services/notification/notification_handler.dart';
import 'package:betaversion/services/notification/notification_permissions.dart';
import 'package:betaversion/utils/device/fcm_token_manager.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Main service for managing push notifications.
///
/// This service orchestrates all notification-related functionality:
/// - Firebase Cloud Messaging integration
/// - Local notification display
/// - Permission management
/// - Token registration
///
/// Usage:
/// ```dart
/// await PushNotificationService.instance.initialize(
///   onNotificationTap: () => print('Notification tapped'),
///   onNotificationPayload: (payload) => handlePayload(payload),
/// );
/// ```
class PushNotificationService {
  /// Factory constructor returns singleton instance
  factory PushNotificationService() => _instance;
  // Private constructor for singleton pattern
  PushNotificationService._internal();

  /// Singleton instance
  static final PushNotificationService _instance =
      PushNotificationService._internal();

  /// Access the singleton instance
  static PushNotificationService get instance => _instance;

  // ============================================================================
  // DEPENDENCIES
  // ============================================================================

  /// Notification display handler
  final NotificationDisplay _display = NotificationDisplay.instance;

  /// Notification handler for FCM messages
  final NotificationHandler _handler = NotificationHandler.instance;

  /// Permission manager
  final NotificationPermissions _permissions = NotificationPermissions.instance;

  /// FCM token manager
  final FcmTokenManager _tokenManager = FcmTokenManager.instance;

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  /// Initializes the push notification service.
  ///
  /// This method sets up:
  /// - Notification channels (Android)
  /// - Local notifications
  /// - Permission requests
  /// - Firebase messaging listeners
  ///
  /// [onNotificationTap] - Callback when notification is tapped
  /// [onNotificationPayload] - Callback with notification payload data
  ///
  /// Throws an exception if initialization fails.
  Future<void> initialize({
    VoidCallback? onNotificationTap,
    ValueChanged<String>? onNotificationPayload,
  }) async {
    try {
      AppLogger.i('🔔 Initializing push notification service...');

      await _setupNotificationChannels();
      await _initializeNotifications(
        onNotificationTap: onNotificationTap,
        onNotificationPayload: onNotificationPayload,
      );
      await _permissions.request(_display.plugin);

      // Note: FCM listeners are NOT set up here automatically
      // Call setupFcmListeners() explicitly after Firebase is initialized

      AppLogger.i('✅ Push notification service initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.e(
        '❌ Failed to initialize push notification service',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  /// Registers FCM token with analytics services.
  ///
  /// Should be called after initialization, typically after user login.
  ///
  /// Returns the token if successful, null otherwise.
  Future<String?> registerFcmToken() async {
    return _tokenManager.registerTokenWithCleverTap();
  }

  /// Gets the current FCM token without registering.
  ///
  /// Useful for displaying token information or debugging.
  Future<String?> getFcmToken() async {
    return _tokenManager.getFcmToken();
  }

  /// Shows a local notification.
  ///
  /// Can be used to display custom notifications independent of FCM.
  Future<void> showNotification({
    required String title,
    required String body,
    String? imageUrl,
    String? payload,
  }) async {
    await _display.show(
      title: title,
      body: body,
      imageUrl: imageUrl,
      payload: payload,
    );
  }

  /// Cancels a notification by ID.
  Future<void> cancelNotification(int id) async {
    await _display.cancel(id);
  }

  /// Cancels all notifications.
  Future<void> cancelAllNotifications() async {
    await _display.cancelAll();
  }

  /// Sets up Firebase Cloud Messaging listeners.
  ///
  /// **Only call this after Firebase has been initialized.**
  /// This is separated from [initialize] to allow local notifications
  /// to work without Firebase.
  ///
  /// [onNotificationPayload] - Optional callback to handle notification data
  void setupFcmListeners({ValueChanged<String>? onNotificationPayload}) {
    _handler.setupListeners(onNotificationPayload: onNotificationPayload);
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  /// Sets up Android notification channels.
  ///
  /// Android 8.0+ requires notification channels for displaying notifications.
  Future<void> _setupNotificationChannels() async {
    try {
      await _display.plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(NotificationConfig.androidChannel);

      AppLogger.i('✅ Notification channels configured');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error setting up notification channels', e, stackTrace);
      rethrow;
    }
  }

  /// Initializes local notification settings for all platforms.
  Future<void> _initializeNotifications({
    VoidCallback? onNotificationTap,
    ValueChanged<String>? onNotificationPayload,
  }) async {
    try {
      await _display.plugin.initialize(
        NotificationConfig.initSettings,
        onDidReceiveNotificationResponse: (details) {
          AppLogger.i('📲 Notification tapped: ${details.payload}');
          if (details.payload != null) {
            onNotificationPayload?.call(details.payload!);
          }
          onNotificationTap?.call();
        },
        onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
      );

      AppLogger.i('✅ Local notifications initialized');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error initializing notifications', e, stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // BACKGROUND HANDLERS
  // ============================================================================

  /// Handler for notification taps when app is in background or terminated.
  ///
  /// This method is marked with @pragma('vm:entry-point') to ensure it's
  /// available for background execution.
  @pragma('vm:entry-point')
  static void _notificationTapBackground(
    NotificationResponse notificationResponse,
  ) {
    // Note: Cannot use AppLogger here as this runs in an isolate
    debugPrint('📲 Notification tapped in background');
    debugPrint('📦 Payload: ${notificationResponse.payload}');
  }
}
