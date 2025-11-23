import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';

/// A full-screen, undismissable blocking overlay for critical app restrictions.
///
/// This overlay is used when the app needs to completely block user interaction
/// due to security concerns or unsupported conditions. It provides a consistent
/// UI for various blocking scenarios.
///
/// Features:
/// - Full-screen dark overlay
/// - Non-dismissable (blocks back button)
/// - Customizable icon, title, message, and warning
/// - Primary action button (customizable)
/// - Follows app's design system
///
/// Example usage for emulator detection:
/// ```dart
/// BlockingOverlay(
///   icon: Icons.devices_other_rounded,
///   title: 'Unsupported Device',
///   message: 'This app cannot run on emulators or virtual devices.',
///   subtitle: 'Please use a physical device to access the app.',
///   warningText: 'Emulators and virtual devices are not supported',
///   actionLabel: 'Exit App',
///   onAction: () => SystemNavigator.pop(),
/// )
/// ```
///
/// Example usage for screen recording:
/// ```dart
/// BlockingOverlay(
///   icon: Icons.videocam_off_rounded,
///   title: 'Screen Recording Detected',
///   message: 'Playback has been paused to prevent unauthorized recording.',
///   subtitle: 'Please stop screen recording to continue watching.',
///   warningText: 'Recording video content is strictly prohibited',
///   actionLabel: null, // No action button, waiting for user to stop recording
/// )
/// ```
class BlockingOverlay extends StatelessWidget {
  const BlockingOverlay({
    required this.icon,
    required this.title,
    required this.message,
    required this.warningText,
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize = 64,
    this.iconColor,
    this.buttonVariant = AppButtonVariant.contained,
    this.buttonSeverity = AppButtonSeverity.error,
    this.backgroundColor,
  }) : assert(
         actionLabel == null || onAction != null,
         'onAction must be provided if actionLabel is not null',
       );

  /// Icon to display at the top
  final IconData icon;

  /// Main title text
  final String title;

  /// Primary message explaining the situation
  final String message;

  /// Optional subtitle with additional instructions
  final String? subtitle;

  /// Warning text displayed in the warning banner
  final String warningText;

  /// Label for the primary action button (null to hide button)
  final String? actionLabel;

  /// Callback for the primary action button
  final VoidCallback? onAction;

  /// Icon size. Defaults to 64
  final double iconSize;

  /// Icon color. If null, uses error color from theme
  final Color? iconColor;

  /// Button variant. Defaults to contained
  final AppButtonVariant buttonVariant;

  /// Button severity. Defaults to error
  final AppButtonSeverity buttonSeverity;

  /// Custom background color. If null, uses scaffold background
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final errorColor = theme.colorScheme.error;
    final surfaceColor = theme.colorScheme.surface;
    final onSurfaceColor = theme.colorScheme.onSurface;

    return PopScope(
      canPop: false, // Prevent back button from dismissing
      child: Material(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.3 * 255).round()),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Large error icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: errorColor.withAlpha((0.1 * 255).round()),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: iconColor ?? errorColor,
                      ),
                    ),
                    const Gap(24),

                    // Title
                    Text(
                      title,
                      style: AppTypography.semiBold20P.copyWith(
                        color: onSurfaceColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16),

                    // Message
                    Text(
                      message,
                      style: AppTypography.bodyLargeRegular.copyWith(
                        color: onSurfaceColor.withAlpha((0.7 * 255).round()),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Optional subtitle
                    if (subtitle != null) ...[
                      const Gap(8),
                      Text(
                        subtitle!,
                        style: AppTypography.bodyMediumRegular.copyWith(
                          color: onSurfaceColor.withAlpha((0.6 * 255).round()),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    const Gap(24),

                    // Warning banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: errorColor.withAlpha((0.15 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: errorColor.withAlpha((0.3 * 255).round()),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            size: 20,
                            color: errorColor,
                          ),
                          const Gap(12),
                          Text(
                            warningText,
                            style: AppTypography.bodySmallMedium.copyWith(
                              color: errorColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ).expanded(),
                        ],
                      ),
                    ),

                    // Action button (optional)
                    if (actionLabel != null && onAction != null) ...[
                      const Gap(24),
                      AppButton(
                        text: actionLabel!,
                        onPressed: onAction,
                        variant: buttonVariant,
                        severity: buttonSeverity,
                        size: AppButtonSize.large,
                        width: double.infinity,
                        borderRadius: 12,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
