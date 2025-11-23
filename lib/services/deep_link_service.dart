/// Deep Link Service
///
/// Manages deep link handling and ensures proper app initialization
/// before navigating to deep link destinations.
///
/// This service:
/// - Tracks app initialization state
/// - Stores pending deep links during initialization
/// - Ensures splash screen is shown first for proper initialization
/// - Listens for deep links from native iOS/Android code via method channel
library;

import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter/services.dart';

/// Service to manage deep link navigation with splash screen integration
class DeepLinkService {
  DeepLinkService._() {
    _setupDeepLinkChannel();
  }

  static final DeepLinkService instance = DeepLinkService._();

  /// Method channel for receiving deep links from native code
  static const MethodChannel _channel = MethodChannel(
    'com.betaversion.app/deeplink',
  );

  /// Flag to track if app has completed initialization
  /// This is the key flag that determines if splash should be shown
  bool _isAppInitialized = false;

  /// Pending deep link path received from native code
  String? _pendingDeepLinkPath;

  /// Callback function to be called when a deep link is received
  void Function(String path)? _onDeepLinkReceived;

  /// Check if app has completed initialization
  bool get isAppInitialized => _isAppInitialized;

  /// Get pending deep link path (if any) and clear it
  String? getPendingDeepLinkPath() {
    final path = _pendingDeepLinkPath;
    _pendingDeepLinkPath = null;
    return path;
  }

  /// Set a callback to be notified when deep links are received
  /// This is useful for handling deep links when the app is already running
  void setDeepLinkCallback(void Function(String path)? callback) {
    _onDeepLinkReceived = callback;
  }

  /// Set up method channel to listen for deep links from iOS/Android
  void _setupDeepLinkChannel() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'handleDeepLink') {
        final String? url = call.arguments as String?;
        if (url != null) {
          _handleIncomingDeepLink(url);
        }
      }
    });
  }

  /// Handle incoming deep link URL from native platform
  void _handleIncomingDeepLink(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;

      // Store the path for navigation after initialization
      _pendingDeepLinkPath = path;

      // If app is initialized and callback is set, immediately navigate
      if (_isAppInitialized && _onDeepLinkReceived != null) {
        _onDeepLinkReceived!(path);
        _pendingDeepLinkPath = null;
      }
    } catch (e, stackTrace) {
      AppLogger.e('Failed to parse deep link URL', e, stackTrace);
    }
  }

  /// Mark app as initialized
  /// Call this after splash screen completes initialization
  void setAppInitialized(bool value) {
    _isAppInitialized = value;
  }

  // ============================================================================
  // BACKWARD COMPATIBILITY ALIASES (DEPRECATED)
  // ============================================================================

  /// @deprecated Use [setAppInitialized(true)] instead
  void markAsInitialized() => setAppInitialized(true);

  /// @deprecated Use [setAppInitialized(true)] instead
  void markSplashCompleted() => setAppInitialized(true);

  /// @deprecated Use [isAppInitialized] instead
  bool isInitialized() => isAppInitialized;

  /// @deprecated Use [isAppInitialized] instead
  bool isOnSplashScreen() => !isAppInitialized;
}
