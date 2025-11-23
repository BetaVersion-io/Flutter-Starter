import 'package:betaversion/core/ui/state/base_state.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// A widget to show an error state.
///
/// This is a specialized wrapper around [BaseStateWidget] with defaults
/// appropriate for error states (e.g., danger icon, error colors).
///
/// All properties can be customized, but sensible defaults are provided
/// for typical error state scenarios.
///
/// Example:
/// ```dart
/// ErrorStateWidget(
///   title: 'Something Went Wrong',
///   message: 'Please try again later',
///   actionLabel: 'Retry',
///   onRetry: () => retryOperation(),
/// )
/// ```
///
/// Example with custom icon and colors:
/// ```dart
/// ErrorStateWidget(
///   icon: Iconsax.warning_2,
///   title: 'Connection Failed',
///   message: 'Unable to connect to the server',
///   iconColor: Colors.orange,
///   actionLabel: 'Try Again',
///   onRetry: () => reconnect(),
/// )
/// ```
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.title,
    super.key,
    this.icon = Iconsax.danger,
    this.message,
    this.iconSize = 80,
    this.iconColor,
    this.onRetry,
    this.actionLabel,
  });

  /// The icon to display. Defaults to [Iconsax.danger]
  final IconData icon;

  /// The main error title text
  final String title;

  /// Optional error description/message
  final String? message;

  /// Size of the icon. Defaults to 80
  final double iconSize;

  /// Color of the icon. If null, uses red shade for errors
  final Color? iconColor;

  /// Optional callback for retry button
  final VoidCallback? onRetry;

  /// Label for the retry button. Required if onRetry is provided
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    // Use red color for error states if no custom color is provided
    final defaultIconColor = iconColor ?? context.customColors.error;

    return BaseStateWidget(
      icon: icon,
      title: title,
      message: message,
      iconSize: iconSize,
      iconColor: defaultIconColor,
      onAction: onRetry,
      actionLabel: actionLabel,
    );
  }
}
