import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/extensions/extension.dart';

part 'app_icon_button.dart';
part 'constant.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.variant = AppButtonVariant.contained,
    this.size = AppButtonSize.medium,
    this.severity = AppButtonSeverity.primary,
    this.icon,
    this.endIcon,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.borderRadius,
    this.elevation,
    this.customColor,
    this.customTextColor,
    this.borderWidth,
    this.customChild,
    this.iconSize,
    this.iconColor,
    this.expanded = false,
    this.margin,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool disabled;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppButtonSeverity severity;
  final IconData? icon;
  final IconData? endIcon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? elevation;
  final Color? customColor;
  final Color? customTextColor;
  final double? borderWidth;
  final Widget? customChild;
  final double? iconSize;
  final Color? iconColor;
  final bool expanded;
  final EdgeInsetsGeometry? margin;

  Color _getBackgroundColor(BuildContext context) {
    if (customColor != null) return customColor!;

    if (variant == AppButtonVariant.text ||
        variant == AppButtonVariant.outlined) {
      return Colors.transparent;
    }

    switch (severity) {
      case AppButtonSeverity.regular:
        return AppColors.grey400;
      case AppButtonSeverity.primary:
        return Theme.of(context).primaryColor;
      case AppButtonSeverity.secondary:
        return AppColors.midNightBlue500;
      case AppButtonSeverity.success:
        return context.customColors.success;
      case AppButtonSeverity.error:
        return context.customColors.error;
      case AppButtonSeverity.warning:
        return AppColors.warning600;
      case AppButtonSeverity.info:
        return AppColors.midNightBlue500;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (customTextColor != null) return customTextColor!;

    final colorScheme = Theme.of(context).colorScheme;

    if (variant == AppButtonVariant.contained) {
      switch (severity) {
        case AppButtonSeverity.regular:
          return colorScheme.onPrimary;
        case AppButtonSeverity.primary:
          return colorScheme.onPrimary;
        case AppButtonSeverity.secondary:
          return colorScheme.onSecondary;
        case AppButtonSeverity.success:
        case AppButtonSeverity.warning:
        case AppButtonSeverity.info:
          return Colors.white;
        case AppButtonSeverity.error:
          return colorScheme.onError;
      }
    } else {
      switch (severity) {
        case AppButtonSeverity.regular:
          return colorScheme.primary;
        case AppButtonSeverity.primary:
          return colorScheme.primary;
        case AppButtonSeverity.secondary:
          return colorScheme.secondary;
        case AppButtonSeverity.success:
          return Colors.green;
        case AppButtonSeverity.error:
          return colorScheme.error;
        case AppButtonSeverity.warning:
          return Colors.orange;
        case AppButtonSeverity.info:
          return Colors.blue;
      }
    }
  }

  Color _getBorderColor(BuildContext context) {
    if (variant != AppButtonVariant.outlined) return Colors.transparent;
    return _getTextColor(context);
  }

  EdgeInsetsGeometry _getPadding() {
    if (padding != null) return padding!;

    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 18, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
      case AppButtonSize.mediumSmall:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 12);
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 13;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 16;
      case AppButtonSize.mediumSmall:
        return 14;
    }
  }

  double _getIconSize() {
    if (iconSize != null) return iconSize!;
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
      case AppButtonSize.mediumSmall:
        return 17;
    }
  }

  double _getLoaderSize() {
    switch (size) {
      case AppButtonSize.small:
        return 14;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 18;
      case AppButtonSize.mediumSmall:
        return 15;
    }
  }

  double _getElevation() {
    if (elevation != null) return elevation!;
    if (variant != AppButtonVariant.contained) return 0;
    return disabled ? 0 : 2;
  }

  double _getBorderRadius() {
    return borderRadius ?? 8;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || isLoading;
    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);
    final borderColor = _getBorderColor(context);

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
      disabledBackgroundColor: variant == AppButtonVariant.contained
          ? backgroundColor.withAlpha(77)
          : Colors.transparent,
      // disabledForegroundColor: textColor.withAlpha(128),
      elevation: _getElevation(),
      shadowColor: Colors.transparent,
      padding: _getPadding(),
      minimumSize: Size(width ?? 0, height ?? 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        side: variant == AppButtonVariant.outlined
            ? BorderSide(
                color: isDisabled ? borderColor.withAlpha(77) : borderColor,
                width: borderWidth ?? 1.5,
              )
            : BorderSide.none,
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    Widget buttonContent =
        customChild ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: _getLoaderSize(),
                height: _getLoaderSize(),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    variant == AppButtonVariant.contained
                        ? textColor
                        : textColor.withAlpha(179),
                  ),
                ),
              ),
              const Gap(8),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: _getIconSize(),
                color:
                    iconColor ??
                    (isDisabled ? textColor.withAlpha(128) : textColor),
              ),
              const Gap(8),
            ],
            Flexible(
              child: Text(
                text,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: _getFontSize(),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: textColor,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (endIcon != null && !isLoading) ...[
              const Gap(8),
              Icon(
                endIcon,
                size: _getIconSize(),
                color:
                    iconColor ??
                    (isDisabled ? textColor.withAlpha(128) : textColor),
              ),
            ],
          ],
        );

    Widget button;

    switch (variant) {
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            disabledForegroundColor: textColor.withAlpha(128),
            padding: _getPadding(),
            minimumSize: Size(width ?? 0, height ?? 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_getBorderRadius()),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: buttonContent,
        );
        break;
      case AppButtonVariant.outlined:
      case AppButtonVariant.contained:
        button = ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: buttonStyle,
          child: buttonContent,
        );
        break;
    }

    Widget finalButton = button;

    if (width != null) {
      finalButton = SizedBox(width: width, height: height, child: finalButton);
    }

    if (expanded) {
      finalButton = Expanded(child: finalButton);
    }

    if (margin != null) {
      finalButton = Container(margin: margin, child: finalButton);
    }

    return finalButton;
  }
}
