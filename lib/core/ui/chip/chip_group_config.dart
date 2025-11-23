import 'package:flutter/material.dart';

/// Configuration for ChipGroup styling and behavior
class ChipGroupConfig {
  // Layout configuration
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry chipPadding;
  final double chipSpacing;
  final double chipHeight;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final Axis scrollDirection;
  final bool scrollable;
  final ScrollPhysics? scrollPhysics;
  final WrapAlignment wrapAlignment;
  final WrapCrossAlignment wrapCrossAlignment;
  final double wrapSpacing;
  final double wrapRunSpacing;
  final bool useWrap;
  final EdgeInsetsGeometry? chipMargin;

  // Border and shape configuration
  final double borderRadius;
  final BorderRadius? customBorderRadius;
  final bool showBorder;
  final BorderSide? borderSide;
  final Border? customBorder;
  final bool showChipBorder;
  final Color? chipBorderColor;
  final double chipBorderWidth;
  final Color? selectedChipBorderColor;

  // Color configuration
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;

  // Typography configuration
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontWeight? selectedFontWeight;

  // Icon configuration
  final double iconSize;
  final double iconSpacing;
  final IconAlignment iconAlignment;

  // Badge configuration
  final Color? badgeColor;
  final Color? badgeTextColor;
  final TextStyle? badgeTextStyle;

  // Interaction configuration
  final bool enabled;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showRipple;
  final Color? rippleColor;
  final Color? splashColor;
  final Color? highlightColor;

  // Selection configuration
  final bool allowMultipleSelection;
  final int? maxSelections;
  final int? minSelections;
  final bool allowDeselection;

  // Shadow and elevation
  final double elevation;
  final double selectedElevation;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? selectedBoxShadow;

  // Container configuration
  final double? containerWidth;
  final double? containerHeight;
  final Color? containerColor;
  final Decoration? containerDecoration;
  final EdgeInsetsGeometry? containerMargin;

  // Selection indicator
  final bool showSelectionIndicator;
  final Widget? selectionIndicator;
  final Color? selectionIndicatorColor;
  final double selectionIndicatorHeight;

  const ChipGroupConfig({
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.chipPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.chipSpacing = 8,
    this.chipHeight = 40,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.scrollDirection = Axis.horizontal,
    this.scrollable = true,
    this.scrollPhysics,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapCrossAlignment = WrapCrossAlignment.center,
    this.wrapSpacing = 8,
    this.wrapRunSpacing = 8,
    this.useWrap = false,
    this.chipMargin,
    this.borderRadius = 32,
    this.customBorderRadius,
    this.showBorder = false,
    this.borderSide,
    this.customBorder,
    this.showChipBorder = false,
    this.chipBorderColor,
    this.chipBorderWidth = 1,
    this.selectedChipBorderColor,
    this.selectedBackgroundColor,
    this.unselectedBackgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.textStyle,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.fontSize = 13,
    this.fontWeight,
    this.selectedFontWeight = FontWeight.w600,
    this.iconSize = 16,
    this.iconSpacing = 8,
    this.iconAlignment = IconAlignment.start,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeTextStyle,
    this.enabled = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.showRipple = true,
    this.rippleColor,
    this.splashColor,
    this.highlightColor,
    this.allowMultipleSelection = false,
    this.maxSelections,
    this.minSelections,
    this.allowDeselection = false,
    this.elevation = 0,
    this.selectedElevation = 0,
    this.boxShadow,
    this.selectedBoxShadow,
    this.containerWidth,
    this.containerHeight,
    this.containerColor,
    this.containerDecoration,
    this.containerMargin,
    this.showSelectionIndicator = false,
    this.selectionIndicator,
    this.selectionIndicatorColor,
    this.selectionIndicatorHeight = 3,
  });
}
