import 'package:betaversion/core/ui/state/base_state.dart';
import 'package:betaversion/hooks/network/use_connectivity.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// No Internet Content Widget
///
/// A reusable widget that displays the no internet UI with automatic
/// reconnection detection. This widget does NOT include a scaffold,
/// making it suitable for use in both:
/// - Full-screen pages (wrapped in AppScaffold)
/// - Inline error states (inside QueryStateBuilder)
///
/// Features:
/// - Automatic detection when internet connection is restored
/// - Auto-retry when connection comes back
/// - Manual "Try Again" button for immediatve retry
/// - Shows connection status (connecting/disconnected)
class NoInternetContent extends HookWidget {
  const NoInternetContent({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.showLoadingIndicator = true,
  });

  /// Optional custom title
  final String? title;

  /// Optional custom message
  final String? message;

  /// Callback when user taps "Try Again" or when connection is restored
  final VoidCallback? onRetry;

  /// Whether to show the loading indicator when connecting
  /// Default is true
  final bool showLoadingIndicator;

  @override
  Widget build(BuildContext context) {
    // Use the connectivity hook for automatic reconnection handling
    final connectivity = useConnectivity(onRetry: onRetry);

    return BaseStateWidget(
      // Image configuration
      mediaPath: 'assets/images/network/no_internet.png',
      mediaWidth: 100,
      mediaHeight: 100,
      mediaFit: BoxFit.contain,
      // icon: Iconsax.activity,
      // icon: Iconsax.activity,

      // Title configuration
      title: connectivity.isCheckingConnection
          ? 'Connecting...'
          : (title ?? 'Looks like you have a network issue'),

      // Message configuration
      message: connectivity.isCheckingConnection
          ? 'Please wait while we restore your connection...'
          : (message ??
                'You are not connected to internet please connect to a Wi-Fi or Mobile Network and Try Again!'),

      // Spacing configuration
      // visualTitleGap: 32,
      // titleMessageGap: 12,
      messageActionGap: 40,

      // Button configuration
      actionLabel: connectivity.isCheckingConnection
          ? 'Connecting...'
          : 'Try Again',
      onAction: connectivity.isCheckingConnection ? null : onRetry,
      buttonIsLoading:
          showLoadingIndicator && connectivity.isCheckingConnection,
      buttonWidth: double.infinity,

      // Layout configuration
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
    ).padding(horizontal: 10, vertical: 40);
  }
}
