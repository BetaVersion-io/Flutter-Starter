import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:betaversion/services/network/connectivity_service.dart';
import 'package:betaversion/theme/extensions/extension.dart';

/// A widget that listens to connectivity changes and shows toast notifications
/// when the user goes online or offline.
///
/// This should be placed high in the widget tree (typically in the App widget)
/// to ensure connectivity status notifications are shown throughout the app.
///
/// Example usage:
/// ```dart
/// MaterialApp.router(
///   builder: (context, child) {
///     return ConnectivityToastListener(
///       child: child ?? const SizedBox(),
///     );
///   },
/// )
/// ```
class ConnectivityToastListener extends HookWidget {
  /// Creates a connectivity toast listener that wraps the given [child].
  const ConnectivityToastListener({required this.child, super.key});

  /// The child widget to display
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final connectivityService = ConnectivityService.instance;

    useEffect(() {
      // Subscribe to connectivity changes
      final subscription = connectivityService.onConnectivityChanged.listen((
        isConnected,
      ) {
        // Only show snackbar if the widget is still mounted
        if (context.mounted) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          // Remove any existing snackbars to avoid stacking
          scaffoldMessenger.clearSnackBars();

          // Show appropriate snackbar based on connectivity status
          final snackBar = SnackBar(
            backgroundColor: isConnected
                ? context.customColors.success
                : context.customColors.error,
            elevation: 0,
            content: Row(
              children: [
                Icon(
                  isConnected ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isConnected ? 'Back online' : 'No internet connection',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration(seconds: isConnected ? 2 : 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(16),
          );

          scaffoldMessenger.showSnackBar(snackBar);
        }
      });

      // Clean up subscription when widget is disposed
      return subscription.cancel;
    }, []);

    return child;
  }
}
