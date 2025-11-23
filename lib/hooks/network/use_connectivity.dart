import 'dart:async';

import 'package:betaversion/services/network/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Result of the connectivity hook
class ConnectivityResult {
  /// Whether the app is currently checking connection after detecting connectivity change
  final bool isCheckingConnection;

  /// Current connectivity status from ConnectivityService
  final bool isConnected;

  const ConnectivityResult({
    required this.isCheckingConnection,
    required this.isConnected,
  });
}

/// Hook for monitoring internet connectivity and handling auto-retry
///
/// This hook listens to connectivity changes and automatically triggers
/// the provided [onRetry] callback when internet connection is restored.
///
/// Features:
/// - Monitors connectivity status in real-time
/// - Auto-triggers retry when connection is restored
/// - Provides checking state for UI feedback
/// - Handles cleanup automatically
///
/// Parameters:
/// - [onRetry] - Optional callback to execute when connection is restored
/// - [autoRetryDelay] - Delay before triggering retry (default: 1000ms)
///
/// Returns [ConnectivityResult] with connection status and checking state
///
/// Example:
/// ```dart
/// final connectivity = useConnectivity(
///   onRetry: () {
///     // Refetch data, retry navigation, etc.
///     query.refetch();
///   },
/// );
///
/// if (connectivity.isCheckingConnection) {
///   return CircularProgressIndicator();
/// }
/// ```
ConnectivityResult useConnectivity({
  VoidCallback? onRetry,
  Duration autoRetryDelay = const Duration(milliseconds: 1000),
}) {
  final isCheckingConnection = useState(false);
  final isConnected = useState(ConnectivityService.instance.isConnected);

  // Memoize the retry callback to avoid BuildContext issues
  final handleRetry = useMemoized(
    () => () {
      if (onRetry != null) {
        onRetry();
      }
    },
    [onRetry],
  );

  // Setup connectivity listener for automatic reconnection
  useEffect(() {
    StreamSubscription<bool>? subscription;

    subscription = ConnectivityService.instance.onConnectivityChanged.listen((
      bool connected,
    ) {
      isConnected.value = connected;

      if (connected) {
        isCheckingConnection.value = true;

        // Give a small delay to show "Connecting..." state
        Future.delayed(autoRetryDelay, () {
          isCheckingConnection.value = false;
          handleRetry();
        });
      }
    });

    // Cleanup on dispose
    return () {
      subscription?.cancel();
    };
  }, [handleRetry, autoRetryDelay]);

  return ConnectivityResult(
    isCheckingConnection: isCheckingConnection.value,
    isConnected: isConnected.value,
  );
}
