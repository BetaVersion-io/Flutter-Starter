import 'package:betaversion/theme/extensions/extension.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum AppBottomSheetVariant {
  standard, // close button in header
  floating, // close button above sheet in circle
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.title,
    required this.child,
    super.key,
    this.variant = AppBottomSheetVariant.standard,
    this.onClose,
    this.padding,
    this.showCloseButton = true,
    this.backgroundColor,
    this.borderRadius = 20,
    this.borderColor,
  });

  final String title;
  final Widget child;
  final AppBottomSheetVariant variant;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? padding;
  final bool showCloseButton;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      AppBottomSheetVariant.standard => _buildStandard(context),
      AppBottomSheetVariant.floating => _buildFloating(context),
    };
  }

  Widget _buildStandard(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).sheetColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius ?? 24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title, close button and border bottom
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 16, 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ).expanded(),
                  if (showCloseButton)
                    IconButton(
                      onPressed: onClose ?? () => Navigator.pop(context),
                      icon: const Icon(Iconsax.close_square),
                      iconSize: 24,
                    ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: padding ?? const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: child,
            ).flexible(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloating(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Floating close button above the sheet
        if (showCloseButton)
          GestureDetector(
            onTap: onClose ?? () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.sheetColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ).padding(bottom: 12),

        // Bottom sheet content
        DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.sheetColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(borderRadius ?? 24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with title only (no close button)
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: theme.dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ).expanded(),
                    ],
                  ),
                ),

                // Content
                Padding(
                  padding: padding ?? const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: child,
                ).flexible(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Static method to show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    AppBottomSheetVariant variant = AppBottomSheetVariant.floating,
    VoidCallback? onClose,
    EdgeInsetsGeometry? padding,
    bool showCloseButton = true,
    Color? backgroundColor,
    double? borderRadius = 20,
    Color? borderColor,
    bool isDismissible = true,
    bool enableDrag = true,
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      constraints: maxHeight != null
          ? BoxConstraints(maxHeight: maxHeight)
          : null,
      useSafeArea: true,
      builder: (context) => AppBottomSheet(
        title: title,
        variant: variant,
        onClose: onClose,
        padding: padding,
        showCloseButton: showCloseButton,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        borderColor: borderColor,
        child: child,
      ),
    );
  }
}
