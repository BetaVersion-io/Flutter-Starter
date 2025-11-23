import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';

/// A reusable load more button widget that shows a loading indicator
/// when fetching more data or a button to trigger loading more data.
///
/// Example usage:
/// ```dart
/// LoadMoreButton(
///   onPressed: fetchNextPage,
///   isLoading: isFetchingNextPage,
/// )
/// ```
class LoadMoreButton extends StatelessWidget {
  const LoadMoreButton({
    required this.onPressed,
    required this.isLoading,
    super.key,
    this.expanded = true,
    this.padding,
  });

  /// Callback to trigger when the load more button is pressed
  final VoidCallback onPressed;

  /// Whether the button should show a loading indicator
  final bool isLoading;

  /// Whether the button should expand to fill available width
  /// Defaults to true for consistency
  final bool expanded;

  /// Padding around the button
  /// Defaults to symmetric horizontal and vertical padding
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final defaultPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 12);

    if (isLoading) {
      return Padding(
        padding: defaultPadding,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // If expanded, center the button with padding
    if (expanded) {
      return Padding(
        padding: defaultPadding,
        child: Center(
          child: AppButton(
            text: 'Load More',
            icon: Iconsax.refresh,
            onPressed: onPressed,
          ),
        ),
      );
    }

    // If not expanded, use Padding wrapper
    return Padding(
      padding: defaultPadding,
      child: AppButton(
        text: 'Load More',
        icon: Iconsax.refresh,
        onPressed: onPressed,
      ),
    );
  }
}
