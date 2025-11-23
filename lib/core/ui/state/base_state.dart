import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/core/ui/media/media_view.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A highly configurable base widget for displaying various states (empty, error, etc.)
///
/// This widget provides a consistent layout for state displays with:
/// - An icon or image at the top (using MediaView for images)
/// - A title
/// - An optional message
/// - An optional action button with full styling control
///
/// Example with icon:
/// ```dart
/// BaseStateWidget(
///   icon: Iconsax.warning_2,
///   title: 'Something went wrong',
///   message: 'Please try again later',
///   actionLabel: 'Retry',
///   onAction: () => print('Retry pressed'),
/// )
/// ```
///
/// Example with image:
/// ```dart
/// BaseStateWidget(
///   mediaPath: 'assets/images/empty_state.png',
///   mediaWidth: 200,
///   mediaHeight: 200,
///   title: 'No items found',
///   message: 'Try adjusting your filters',
///   actionLabel: 'Clear Filters',
///   onAction: () => clearFilters(),
///   buttonVariant: AppButtonVariant.outlined,
/// )
/// ```
class BaseStateWidget extends StatelessWidget {
  const BaseStateWidget({
    // Text content
    required this.title,
    super.key,
    // Visual element (icon or media)
    this.icon,
    this.iconSize = 80,
    this.iconColor,
    this.mediaPath,
    this.mediaWidth,
    this.mediaHeight,
    this.mediaFit = BoxFit.cover,
    this.mediaPlaceholderPath,
    this.mediaPlaceholder,
    this.mediaErrorWidget,
    this.isMediaRound = false,
    this.mediaBorderRadius,
    this.mediaBackground = Colors.transparent,
    this.mediaTintColor,
    this.mediaBlendMode,
    this.mediaMargin = const EdgeInsets.all(0),
    this.mediaPadding = const EdgeInsets.all(0),
    this.message,
    this.titleFontSize = 20,
    this.titleFontWeight = FontWeight.w700,
    this.titleColor,
    this.titleStyle,
    this.titleAlign = TextAlign.center,
    this.messageFontSize = 14,
    this.messageColor,
    this.messageStyle,
    this.messageAlign = TextAlign.center,
    this.messagePadding = const EdgeInsets.symmetric(horizontal: 32),
    // Spacing
    this.visualTitleGap = 24,
    this.titleMessageGap = 8,
    this.messageActionGap = 16,
    // Action button
    this.onAction,
    this.actionLabel,
    this.buttonVariant = AppButtonVariant.contained,
    this.buttonSize = AppButtonSize.medium,
    this.buttonSeverity = AppButtonSeverity.primary,
    this.buttonIcon,
    this.buttonEndIcon,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonPadding,
    this.buttonTextStyle,
    this.buttonBorderRadius,
    this.buttonElevation,
    this.buttonCustomColor,
    this.buttonCustomTextColor,
    this.buttonBorderWidth,
    this.buttonMargin,
    this.buttonIsLoading = false,
    // Layout
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : assert(
         icon != null || mediaPath != null,
         'Either icon or mediaPath must be provided',
       ),
       assert(
         onAction == null || actionLabel != null,
         'actionLabel must be provided if onAction is not null',
       );
  // ========== Visual Element (Icon or Image) ==========
  /// The icon to display at the top. Either [icon] or [mediaPath] should be provided
  final IconData? icon;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon. If null, defaults to grey500
  final Color? iconColor;

  /// Path to the image/media to display instead of icon
  final String? mediaPath;

  /// Width of the media view
  final double? mediaWidth;

  /// Height of the media view
  final double? mediaHeight;

  /// Box fit for the media
  final BoxFit mediaFit;

  /// Media placeholder path
  final String? mediaPlaceholderPath;

  /// Media placeholder widget
  final Widget? mediaPlaceholder;

  /// Media error widget
  final Widget? mediaErrorWidget;

  /// Whether media should be round
  final bool isMediaRound;

  /// Media border radius
  final BorderRadius? mediaBorderRadius;

  /// Media background color
  final Color mediaBackground;

  /// Media tint color
  final Color? mediaTintColor;

  /// Media blend mode
  final BlendMode? mediaBlendMode;

  /// Media margin
  final EdgeInsetsGeometry mediaMargin;

  /// Media padding
  final EdgeInsetsGeometry mediaPadding;

  // ========== Text Content ==========
  /// The main title text
  final String title;

  /// Optional descriptive message
  final String? message;

  /// Title font size
  final double titleFontSize;

  /// Title font weight
  final FontWeight titleFontWeight;

  /// Title text color. If null, defaults to grey700
  final Color? titleColor;

  /// Title text style (overrides fontSize, fontWeight, color if provided)
  final TextStyle? titleStyle;

  /// Title text alignment
  final TextAlign titleAlign;

  /// Message font size
  final double messageFontSize;

  /// Message text color. If null, defaults to grey500
  final Color? messageColor;

  /// Message text style (overrides fontSize, color if provided)
  final TextStyle? messageStyle;

  /// Message text alignment
  final TextAlign messageAlign;

  /// Message padding
  final EdgeInsetsGeometry messagePadding;

  // ========== Spacing ==========
  /// Gap between icon/media and title
  final double visualTitleGap;

  /// Gap between title and message
  final double titleMessageGap;

  /// Gap between message and action button
  final double messageActionGap;

  // ========== Action Button ==========
  /// Optional callback for action button
  final VoidCallback? onAction;

  /// Label for the action button. Required if onAction is provided
  final String? actionLabel;

  /// Button variant (contained, outlined, text)
  final AppButtonVariant buttonVariant;

  /// Button size
  final AppButtonSize buttonSize;

  /// Button severity (primary, secondary, success, error, etc.)
  final AppButtonSeverity buttonSeverity;

  /// Button icon
  final IconData? buttonIcon;

  /// Button end icon
  final IconData? buttonEndIcon;

  /// Button width
  final double? buttonWidth;

  /// Button height
  final double? buttonHeight;

  /// Button padding
  final EdgeInsetsGeometry? buttonPadding;

  /// Button text style
  final TextStyle? buttonTextStyle;

  /// Button border radius
  final double? buttonBorderRadius;

  /// Button elevation
  final double? buttonElevation;

  /// Button custom color
  final Color? buttonCustomColor;

  /// Button custom text color
  final Color? buttonCustomTextColor;

  /// Button border width
  final double? buttonBorderWidth;

  /// Button margin
  final EdgeInsetsGeometry? buttonMargin;

  /// Button is loading
  final bool buttonIsLoading;

  // ========== Layout ==========
  /// Main axis alignment for the column
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment for the column
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final grey500 = Colors.grey.shade500;
    final grey700 = Colors.grey.shade700;

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        // Visual element (Icon or Media)
        _buildVisualElement(grey500),
        Gap(visualTitleGap),

        // Title
        Text(
          title,
          style:
              titleStyle ??
              TextStyle(
                fontSize: titleFontSize,
                fontWeight: titleFontWeight,
                color: titleColor,
              ),
          textAlign: titleAlign,
        ),

        // Message
        if (message != null) ...[
          Gap(titleMessageGap),
          Padding(
            padding: messagePadding,
            child: Text(
              message!,
              style:
                  messageStyle ??
                  TextStyle(
                    fontSize: messageFontSize,
                    color: messageColor ?? grey500,
                  ),
              textAlign: messageAlign,
            ),
          ),
        ],

        // Action button
        if (onAction != null && actionLabel != null) ...[
          Gap(messageActionGap),
          AppButton(
            text: actionLabel!,
            onPressed: onAction,
            variant: buttonVariant,
            size: buttonSize,
            severity: buttonSeverity,
            icon: buttonIcon,
            endIcon: buttonEndIcon,
            width: buttonWidth,
            height: buttonHeight,
            padding: buttonPadding,
            textStyle: buttonTextStyle,
            borderRadius: buttonBorderRadius,
            elevation: buttonElevation,
            customColor: buttonCustomColor,
            customTextColor: buttonCustomTextColor,
            borderWidth: buttonBorderWidth,
            margin: buttonMargin,
            isLoading: buttonIsLoading,
          ),
        ],
      ],
    ).center();
  }

  /// Builds the visual element (either icon or media)
  Widget _buildVisualElement(Color defaultIconColor) {
    if (mediaPath != null) {
      return MediaView.universal(
        path: mediaPath,
        width: mediaWidth,
        height: mediaHeight,
        fit: mediaFit,
        placeHolderPath: mediaPlaceholderPath,
        placeHolder: mediaPlaceholder,
        errorWidget: mediaErrorWidget,
        isImageRound: isMediaRound,
        borderRadius: mediaBorderRadius,
        background: mediaBackground,
        tintColor: mediaTintColor,
        blendMode: mediaBlendMode,
        margin: mediaMargin,
        padding: mediaPadding,
      );
    } else {
      return Icon(icon, size: iconSize, color: iconColor ?? defaultIconColor);
    }
  }
}
