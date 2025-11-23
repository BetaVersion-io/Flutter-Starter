import 'dart:convert';
import 'dart:io';

import 'package:betaversion/services/notification/notification_config.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Handles displaying local notifications.
///
/// Responsible for:
/// - Showing notifications with platform-specific styling
/// - Loading and processing notification images
/// - Managing notification IDs
class NotificationDisplay {
  // Private constructor
  NotificationDisplay._();

  /// Singleton instance
  static final NotificationDisplay _instance = NotificationDisplay._();

  /// Access the singleton instance
  static NotificationDisplay get instance => _instance;

  /// Flutter local notifications plugin instance
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Get the notifications plugin instance
  FlutterLocalNotificationsPlugin get plugin => _plugin;

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  /// Displays a local notification with optional image.
  ///
  /// [title] - Notification title
  /// [body] - Notification body text
  /// [imageUrl] - Optional image URL to display in notification
  /// [payload] - JSON-encoded data to pass when notification is tapped
  Future<void> show({
    required String title,
    required String body,
    String? imageUrl,
    String? payload,
  }) async {
    try {
      BigPictureStyleInformation? bigPictureStyle;
      DarwinNotificationDetails? darwinDetails;

      // Load and process notification image if provided
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final imageDetails = await _loadImage(imageUrl, title, body);
        bigPictureStyle = imageDetails.$1;
        darwinDetails = imageDetails.$2;
      }

      // Build platform-specific notification details
      final androidDetails = bigPictureStyle != null
          ? NotificationConfig.androidDetailsWithImage(bigPictureStyle)
          : NotificationConfig.androidDetails;

      final iosDetails = darwinDetails ?? const DarwinNotificationDetails();

      final platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
        macOS: iosDetails,
      );

      // Show notification with unique ID
      await _plugin.show(
        _generateNotificationId(),
        title,
        body,
        platformDetails,
        payload: payload,
      );

      AppLogger.i('✅ Notification displayed: $title');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error showing notification', e, stackTrace);
    }
  }

  /// Cancels a notification by ID.
  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id);
      AppLogger.i('✅ Notification cancelled: $id');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error cancelling notification', e, stackTrace);
    }
  }

  /// Cancels all notifications.
  Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
      AppLogger.i('✅ All notifications cancelled');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error cancelling all notifications', e, stackTrace);
    }
  }

  // ============================================================================
  // PRIVATE METHODS
  // ============================================================================

  /// Generates a unique notification ID based on current timestamp.
  int _generateNotificationId() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Loads and processes notification image for platform-specific display.
  ///
  /// Returns a record containing Android BigPictureStyle and iOS/macOS details.
  Future<(BigPictureStyleInformation?, DarwinNotificationDetails?)> _loadImage(
    String imageUrl,
    String title,
    String body,
  ) async {
    try {
      final http.Response response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        AppLogger.w('⚠️ Failed to load image: ${response.statusCode}');
        return (null, null);
      }

      if (Platform.isAndroid) {
        return (_buildAndroidBigPicture(response.bodyBytes, title, body), null);
      } else if (Platform.isIOS || Platform.isMacOS) {
        return (null, await _buildDarwinAttachment(response.bodyBytes));
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error loading notification image', e, stackTrace);
    }

    return (null, null);
  }

  /// Builds Android BigPictureStyleInformation from image bytes.
  BigPictureStyleInformation _buildAndroidBigPicture(
    List<int> imageBytes,
    String title,
    String body,
  ) {
    final base64Image = base64Encode(imageBytes);
    final bitmap = ByteArrayAndroidBitmap.fromBase64String(base64Image);

    return BigPictureStyleInformation(
      bitmap,
      largeIcon: bitmap,
      contentTitle: title,
      summaryText: body,
    );
  }

  /// Builds iOS/macOS DarwinNotificationDetails with image attachment.
  Future<DarwinNotificationDetails> _buildDarwinAttachment(
    List<int> imageBytes,
  ) async {
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = '${dir.path}/notification_$timestamp.png';
    final file = File(filename);
    await file.writeAsBytes(imageBytes);

    return DarwinNotificationDetails(
      attachments: [DarwinNotificationAttachment(filename)],
    );
  }
}
