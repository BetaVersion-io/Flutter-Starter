import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Configuration constants for push notifications.
///
/// Contains all notification-related constants including channel IDs,
/// names, descriptions, and platform-specific settings.
class NotificationConfig {
  // Private constructor to prevent instantiation
  NotificationConfig._();

  // ============================================================================
  // ANDROID CHANNEL CONFIGURATION
  // ============================================================================

  /// Android notification channel ID.
  ///
  /// Must match across app sessions for consistency.
  static const String channelId = 'high_importance_channel';

  /// Android notification channel name.
  ///
  /// Displayed to users in system notification settings.
  static const String channelName = 'Important Notifications';

  /// Android notification channel description.
  ///
  /// Helps users understand the purpose of this channel.
  static const String channelDescription =
      'This channel is used for important notifications';

  /// Android notification icon resource name.
  ///
  /// Must exist in android/app/src/main/res/drawable/
  static const String notificationIcon = 'logo';

  /// Android notification color.
  static const Color notificationColor = Colors.blue;

  // ============================================================================
  // NOTIFICATION SETTINGS
  // ============================================================================

  /// Android notification channel configuration.
  static const AndroidNotificationChannel androidChannel =
      AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
        playSound: true,
      );

  /// Android notification details template.
  static AndroidNotificationDetails get androidDetails =>
      const AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        colorized: true,
        color: notificationColor,
        icon: notificationIcon,
      );

  /// Android notification details with image support.
  static AndroidNotificationDetails androidDetailsWithImage(
    BigPictureStyleInformation styleInformation,
  ) => AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    colorized: true,
    color: notificationColor,
    icon: notificationIcon,
    styleInformation: styleInformation,
  );

  // ============================================================================
  // INITIALIZATION SETTINGS
  // ============================================================================

  /// Android initialization settings.
  static const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings(notificationIcon);

  /// iOS/macOS initialization settings.
  ///
  /// Permissions are requested separately, so all are set to false here.
  static const DarwinInitializationSettings darwinInitSettings =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

  /// Linux initialization settings.
  static const LinuxInitializationSettings linuxInitSettings =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  /// Combined initialization settings for all platforms.
  static const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
    iOS: darwinInitSettings,
    macOS: darwinInitSettings,
    linux: linuxInitSettings,
  );
}
