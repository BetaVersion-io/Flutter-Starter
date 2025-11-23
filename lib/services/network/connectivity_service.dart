import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Connectivity Service
///
/// This service monitors network connectivity and provides:
/// - Real-time connectivity status updates via stream
/// - Current connection status check
/// - Easy integration with widgets and services
///
/// Example usage:
/// ```dart
/// // Check current status
/// bool isConnected = await ConnectivityService.instance.isConnected;
///
/// // Listen to connectivity changes
/// ConnectivityService.instance.onConnectivityChanged.listen((isConnected) {
///   if (isConnected) {
///     print('Internet connection restored!');
///   } else {
///     print('No internet connection');
///   }
/// });
/// ```
class ConnectivityService {
  ConnectivityService._();

  static final ConnectivityService _instance = ConnectivityService._();
  static ConnectivityService get instance => _instance;

  final Connectivity _connectivity = Connectivity();

  /// Stream controller for connectivity status changes
  final _connectionStatusController = StreamController<bool>.broadcast();

  /// Stream of connectivity status (true = connected, false = disconnected)
  Stream<bool> get onConnectivityChanged => _connectionStatusController.stream;

  /// Current connectivity status
  bool _isConnected = true;

  /// Get current connectivity status
  bool get isConnected => _isConnected;

  /// Initialize the connectivity service
  ///
  /// This should be called once during app initialization
  Future<void> initialize() async {
    // Check initial connectivity
    _isConnected = await _checkConnectivity();

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) async {
      final bool wasConnected = _isConnected;
      _isConnected = await _checkConnectivity();

      // Only emit if status actually changed
      if (wasConnected != _isConnected) {
        _connectionStatusController.add(_isConnected);

        if (kDebugMode) {
          if (_isConnected) {
            print('🌐 Internet connection restored');
          } else {
            print('🚫 Internet connection lost');
          }
        }
      }
    });
  }

  /// Check current connectivity status
  Future<bool> _checkConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();

      // Check if any of the results indicate connectivity
      // Ignore VPN and Bluetooth as they might not provide internet
      return results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking connectivity: $e');
      }
      return false;
    }
  }

  /// Manually refresh connectivity status
  Future<bool> refreshConnectivity() async {
    final bool wasConnected = _isConnected;
    _isConnected = await _checkConnectivity();

    if (wasConnected != _isConnected) {
      _connectionStatusController.add(_isConnected);
    }

    return _isConnected;
  }

  /// Dispose the service
  void dispose() {
    _connectionStatusController.close();
  }
}
