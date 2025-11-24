part of 'app_button.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool disabled;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final AppButtonSeverity severity;
  final String? tooltip;
  final Color? customColor;
  final Color? customIconColor;
  final double? borderWidth;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.disabled = false,
    this.variant = AppButtonVariant.text,
    this.size = AppButtonSize.medium,
    this.severity = AppButtonSeverity.regular,
    this.tooltip,
    this.customColor,
    this.customIconColor,
    this.borderWidth,
  });

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 18;
      case AppButtonSize.medium:
        return 24;
      case AppButtonSize.large:
        return 26;
      case AppButtonSize.extrasmall:
        return 21;
    }
  }

  double _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 40;
      case AppButtonSize.large:
        return 48;
      case AppButtonSize.extrasmall:
        return 36;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (customColor != null) return customColor!;

    final colorScheme = Theme.of(context).colorScheme;

    if (variant == AppButtonVariant.text ||
        variant == AppButtonVariant.outlined) {
      return Colors.transparent;
    }

    switch (severity) {
      case AppButtonSeverity.regular:
        return colorScheme.onPrimary;
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

  Color _getIconColor(BuildContext context) {
    if (customIconColor != null) return customIconColor!;

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
          return colorScheme.onSurface;
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

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || isLoading;
    final backgroundColor = _getBackgroundColor(context);
    final iconColor = _getIconColor(context);
    final buttonSize = _getButtonSize();

    Widget iconWidget = isLoading
        ? SizedBox(
            width: _getIconSize() * 0.8,
            height: _getIconSize() * 0.8,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          )
        : Icon(
            icon,
            size: _getIconSize(),
            color: isDisabled ? iconColor.withAlpha(125) : iconColor,
          );

    Widget button;

    switch (variant) {
      case AppButtonVariant.text:
        button = IconButton(
          onPressed: isDisabled ? null : onPressed,
          icon: iconWidget,
          iconSize: _getIconSize(),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: buttonSize,
            minHeight: buttonSize,
            maxWidth: buttonSize,
            maxHeight: buttonSize,
          ),
          color: iconColor,
          disabledColor: iconColor.withAlpha(125),
          tooltip: tooltip,
        );
        break;
      case AppButtonVariant.outlined:
        button = Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDisabled ? iconColor.withAlpha(77) : iconColor,
              width: borderWidth ?? 1.5,
            ),
          ),
          child: IconButton(
            onPressed: isDisabled ? null : onPressed,
            icon: iconWidget,
            iconSize: _getIconSize(),
            padding: EdgeInsets.zero,
            color: iconColor,
            disabledColor: iconColor.withAlpha(128),
            tooltip: tooltip,
          ),
        );
        break;
      case AppButtonVariant.contained:
        button = Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDisabled ? backgroundColor.withAlpha(77) : backgroundColor,
            boxShadow: !isDisabled
                ? [
                    BoxShadow(
                      color: backgroundColor.withAlpha(77),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: IconButton(
            onPressed: isDisabled ? null : onPressed,
            icon: iconWidget,
            iconSize: _getIconSize(),
            padding: EdgeInsets.zero,
            color: iconColor,
            disabledColor: iconColor.withAlpha(128),
            tooltip: tooltip,
          ),
        );
        break;
    }

    return button;
  }
}
