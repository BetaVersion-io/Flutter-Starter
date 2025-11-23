import 'package:betaversion/core/ui/state/base_state.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// A widget to show an empty or no-data state.
///
/// This is a specialized wrapper around [BaseStateWidget] with defaults
/// appropriate for empty states (e.g., filter_remove icon).
///
/// All properties can be customized, but sensible defaults are provided
/// for typical empty state scenarios.
///
/// Example:
/// ```dart
/// EmptyStateWidget(
///   title: 'No Solutions Found',
///   message: 'No solutions match the selected filter',
/// )
/// ```
///
/// Example with custom icon and action:
/// ```dart
/// EmptyStateWidget(
///   icon: Iconsax.clipboard_text,
///   title: 'No Data Available',
///   message: 'Try adding some items first',
///   actionLabel: 'Add Item',
///   onRetry: () => print('Add item pressed'),
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    super.key,
    this.icon = Iconsax.filter_remove,
    this.message,
    this.iconSize = 80,
    this.iconColor,
    this.onRetry,
    this.actionLabel,
  });

  /// The icon to display. Defaults to [Iconsax.filter_remove]
  final IconData icon;

  /// The main title text
  final String title;

  /// Optional descriptive message
  final String? message;

  /// Size of the icon. Defaults to 80
  final double iconSize;

  /// Color of the icon. If null, uses default grey
  final Color? iconColor;

  /// Optional callback for retry/action button
  final VoidCallback? onRetry;

  /// Label for the action button. Required if onRetry is provided
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return BaseStateWidget(
      icon: icon,
      title: title,
      message: message,
      iconSize: iconSize,
      iconColor: iconColor,
      onAction: onRetry,
      actionLabel: actionLabel,
    );
  }
}
