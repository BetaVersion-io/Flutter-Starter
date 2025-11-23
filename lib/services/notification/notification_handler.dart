import 'dart:convert';
import 'dart:io';

import 'package:betaversion/services/notification/notification_display.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

/// Handles Firebase Cloud Messaging notifications.
///
/// Responsible for:
/// - Setting up FCM listeners
/// - Processing incoming messages
/// - Routing notifications to display handler
///
/// **Note:** This handler only works if Firebase is initialized.
/// Call [setupListeners] only after Firebase initialization.
class NotificationHandler {
  // Private constructor
  NotificationHandler._();

  /// Singleton instance
  static final NotificationHandler _instance = NotificationHandler._();

  /// Access the singleton instance
  static NotificationHandler get instance => _instance;

  /// Notification display handler
  final NotificationDisplay _display = NotificationDisplay.instance;

  /// Tracks if FCM listeners are set up
  bool _listenersSetup = false;

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  /// Sets up Firebase Cloud Messaging listeners.
  ///
  /// **IMPORTANT:** Only call this method after Firebase has been initialized.
  /// If Firebase is not initialized, this method will log a warning and return.
  ///
  /// Handles three notification scenarios:
  /// 1. App opened from terminated state via notification
  /// 2. Notification received while app is in foreground
  /// 3. App opened from background state via notification
  ///
  /// [onNotificationPayload] - Optional callback to handle notification data
  void setupListeners({ValueChanged<String>? onNotificationPayload}) {
    // Check if Firebase is initialized
    if (!_isFirebaseInitialized()) {
      AppLogger.w('⚠️ Skipping FCM listener setup - Firebase not initialized');
      return;
    }

    if (_listenersSetup) {
      AppLogger.w('⚠️ FCM listeners already set up');
      return;
    }

    try {
      // Handle notification that opened app from terminated state
      FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage? message,
      ) {
        if (message != null) {
          AppLogger.i('📬 Initial message received: ${message.messageId}');
          _handleMessage(message, onNotificationPayload: onNotificationPayload);
        }
      });

      // Handle notification received while app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        AppLogger.i('📨 Foreground message received: ${message.messageId}');
        _handleMessage(message, onNotificationPayload: onNotificationPayload);
      });

      // Handle notification that opened app from background state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        AppLogger.i('📭 Background message opened: ${message.messageId}');
        _handleMessage(message, onNotificationPayload: onNotificationPayload);
      });

      _listenersSetup = true;
      AppLogger.i('✅ Firebase listeners configured');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error setting up Firebase listeners', e, stackTrace);
    }
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  /// Checks if Firebase has been initialized.
  bool _isFirebaseInitialized() {
    try {
      Firebase.app();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  /// Handles incoming Firebase Cloud Messaging notifications.
  ///
  /// Processes the message and displays a local notification if needed.
  void _handleMessage(
    RemoteMessage message, {
    ValueChanged<String>? onNotificationPayload,
  }) {
    try {
      AppLogger.d('📩 Processing message: ${message.messageId}');
      AppLogger.d('📦 Message data: ${message.data}');

      final notification = message.notification;
      if (notification != null) {
        final imageUrl = Platform.isAndroid
            ? notification.android?.imageUrl
            : notification.apple?.imageUrl;

        _display.show(
          title: notification.title ?? 'New Notification',
          body: notification.body ?? '',
          imageUrl: imageUrl,
          payload: jsonEncode(message.data),
        );
      }

      if (message.data.isNotEmpty) {
        onNotificationPayload?.call(jsonEncode(message.data));
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error handling message', e, stackTrace);
    }
  }
}
