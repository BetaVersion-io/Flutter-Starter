import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:betaversion/hooks/theme/use_theme.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:betaversion/theme/extensions/extension.dart';

/// Individual chip item widget
class ChipItem extends HookWidget {
  const ChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.index,
    super.key,
    this.count,
    this.showRedDot = false,
    this.chipPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.chipHeight = 40,
    this.borderRadius = 32,
    this.customBorderRadius,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.textStyle,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.fontSize = 13,
    this.selectedFontWeight = FontWeight.w600,
    this.showChipBorder = false,
    this.chipBorderColor,
    this.chipBorderWidth = 1,
    this.selectedChipBorderColor,
    this.icon,
    this.customIcon,
    this.iconSize = 16,
    this.iconSpacing = 8,
    this.iconAlignment = IconAlignment.start,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeTextStyle,
    this.enabled = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.onLongPress,
    this.onDoubleTap,
    this.elevation = 0,
    this.selectedElevation = 0,
    this.boxShadow,
    this.selectedBoxShadow,
    this.showSelectionIndicator = false,
    this.selectionIndicator,
    this.selectionIndicatorColor,
    this.selectionIndicatorHeight = 3,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;
  final bool showRedDot;
  final int index;

  // Styling
  final EdgeInsetsGeometry chipPadding;
  final double chipHeight;
  final double borderRadius;
  final BorderRadius? customBorderRadius;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final double fontSize;
  final FontWeight? selectedFontWeight;

  // Border
  final bool showChipBorder;
  final Color? chipBorderColor;
  final double chipBorderWidth;
  final Color? selectedChipBorderColor;

  // Icon
  final IconData? icon;
  final Widget? customIcon;
  final double iconSize;
  final double iconSpacing;
  final IconAlignment iconAlignment;

  // Badge
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final TextStyle? badgeTextStyle;

  // Interaction
  final bool enabled;
  final Duration animationDuration;
  final Curve animationCurve;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  // Shadow
  final double elevation;
  final double selectedElevation;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? selectedBoxShadow;

  // Selection indicator
  final bool showSelectionIndicator;
  final Widget? selectionIndicator;
  final Color? selectionIndicatorColor;
  final double selectionIndicatorHeight;

  @override
  Widget build(BuildContext context) {
    final theme = useTheme();
    final hasCount = count != null;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      onDoubleTap: enabled ? onDoubleTap : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            height: chipHeight,
            duration: animationDuration,
            curve: animationCurve,
            padding: chipPadding,
            decoration: BoxDecoration(
              color: isSelected
                  ? (selectedBackgroundColor ?? AppColors.midNightBlue400)
                  : (unselectedBackgroundColor ?? theme.paperColor),
              borderRadius:
                  customBorderRadius ?? BorderRadius.circular(borderRadius),
              border: showChipBorder
                  ? Border.all(
                      color: isSelected
                          ? (selectedChipBorderColor ??
                                chipBorderColor ??
                                Colors.transparent)
                          : (chipBorderColor ?? Colors.transparent),
                      width: chipBorderWidth,
                    )
                  : null,
              boxShadow: isSelected
                  ? (selectedBoxShadow ??
                        (selectedElevation > 0
                            ? _defaultShadow(selectedElevation)
                            : null))
                  : (boxShadow ??
                        (elevation > 0 ? _defaultShadow(elevation) : null)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null || customIcon != null) ...[
                  customIcon ??
                      Icon(
                        icon,
                        size: iconSize,
                        color: isSelected
                            ? (selectedTextColor ?? Colors.white)
                            : (unselectedTextColor ??
                                  Theme.of(context).colorScheme.onSurface),
                      ),
                  SizedBox(width: iconSpacing),
                ],
                Text(
                  label,
                  style: isSelected
                      ? (selectedTextStyle ??
                            textStyle?.copyWith(
                              color: selectedTextColor ?? Colors.white,
                              fontWeight: selectedFontWeight,
                            ) ??
                            AppTypography.bodySmallRegular.copyWith(
                              color: selectedTextColor ?? Colors.white,
                              fontWeight: selectedFontWeight,
                            ))
                      : (unselectedTextStyle ??
                            textStyle?.copyWith(
                              color:
                                  unselectedTextColor ??
                                  Theme.of(context).colorScheme.onSurface,
                            ) ??
                            AppTypography.bodySmallRegular.copyWith(
                              color:
                                  unselectedTextColor ??
                                  Theme.of(context).colorScheme.onSurface,
                            )),
                ),
                if (hasCount) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.2)
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      count.toString(),
                      style: AppTypography.bodySmallRegular.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor ?? Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge!,
                      style:
                          badgeTextStyle ??
                          TextStyle(
                            color: badgeTextColor ?? Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showRedDot && index == 2)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (showSelectionIndicator && isSelected)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child:
                  selectionIndicator ??
                  Container(
                    height: selectionIndicatorHeight,
                    color:
                        selectionIndicatorColor ??
                        (selectedBackgroundColor ?? AppColors.midNightBlue400),
                  ),
            ),
        ],
      ),
    );
  }

  List<BoxShadow> _defaultShadow(double elevation) {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: elevation,
        offset: Offset(0, elevation / 2),
      ),
    ];
  }
}
