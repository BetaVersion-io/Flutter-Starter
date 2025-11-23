import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:betaversion/core/ui/chip/chip_item.dart';

/// A widget that displays a group of selectable chips
class ChipGroup extends HookWidget {
  const ChipGroup({
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    super.key,
    this.prefixWidgets = const [],
    this.suffixWidgets = const [],
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
    this.borderRadius = 32,
    this.customBorderRadius,
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
    this.showBorder = false,
    this.counts,
    this.showRedDot = false,
    this.borderSide,
    this.customBorder,
    this.showChipBorder = false,
    this.chipBorderColor,
    this.chipBorderWidth = 1,
    this.selectedChipBorderColor,
    this.icons,
    this.customIcons,
    this.iconSize = 16,
    this.iconSpacing = 8,
    this.iconAlignment = IconAlignment.start,
    this.badges,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeTextStyle,
    this.enabled = true,
    this.individualEnabledStates,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.showRipple = true,
    this.rippleColor,
    this.splashColor,
    this.highlightColor,
    this.allowMultipleSelection = false,
    this.selectedIndices,
    this.maxSelections,
    this.minSelections,
    this.allowDeselection = false,
    this.onLongPress,
    this.onDoubleTap,
    this.onMultipleSelectionChanged,
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
    this.chipMargin,
  });
  final List<String> labels;
  final int selectedIndex;
  final void Function(int index) onChanged;

  final List<Widget> suffixWidgets;
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

  final double borderRadius;
  final BorderRadius? customBorderRadius;
  final Color? selectedBackgroundColor;
  final Color? unselectedBackgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final double fontSize;
  final FontWeight? fontWeight;
  final FontWeight? selectedFontWeight;

  final bool showBorder;
  final List<Widget> prefixWidgets;
  final List<int>? counts;
  final bool showRedDot;
  final BorderSide? borderSide;
  final Border? customBorder;
  final bool showChipBorder;
  final Color? chipBorderColor;
  final double chipBorderWidth;
  final Color? selectedChipBorderColor;

  final List<IconData?>? icons;
  final List<Widget?>? customIcons;
  final double iconSize;
  final double iconSpacing;
  final IconAlignment iconAlignment;

  final List<String?>? badges;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final TextStyle? badgeTextStyle;

  final bool enabled;
  final List<bool>? individualEnabledStates;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showRipple;
  final Color? rippleColor;
  final Color? splashColor;
  final Color? highlightColor;

  final bool allowMultipleSelection;
  final List<int>? selectedIndices;
  final int? maxSelections;
  final int? minSelections;
  final bool allowDeselection;

  final void Function(int index)? onLongPress;
  final void Function(int index)? onDoubleTap;
  final void Function(List<int> indices)? onMultipleSelectionChanged;

  final double elevation;
  final double selectedElevation;
  final List<BoxShadow>? boxShadow;
  final List<BoxShadow>? selectedBoxShadow;

  final double? containerWidth;
  final double? containerHeight;
  final Color? containerColor;
  final Decoration? containerDecoration;
  final EdgeInsetsGeometry? containerMargin;

  final bool showSelectionIndicator;
  final Widget? selectionIndicator;
  final Color? selectionIndicatorColor;
  final double selectionIndicatorHeight;

  @override
  Widget build(BuildContext context) {
    final segmentContent = SingleChildScrollView(
      scrollDirection: scrollDirection,
      padding: padding,
      physics: scrollPhysics,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ...prefixWidgets,
          ...List.generate(labels.length, (index) {
            final bool isSelected = selectedIndex == index;
            final bool hasCount = counts != null && index < counts!.length;
            final int? count = hasCount ? counts![index] : null;
            final bool isEnabled =
                individualEnabledStates != null &&
                    index < individualEnabledStates!.length
                ? individualEnabledStates![index]
                : enabled;
            final IconData? icon = icons != null && index < icons!.length
                ? icons![index]
                : null;
            final Widget? customIcon =
                customIcons != null && index < customIcons!.length
                ? customIcons![index]
                : null;
            final String? badge = badges != null && index < badges!.length
                ? badges![index]
                : null;

            return Padding(
              padding: chipMargin ?? EdgeInsets.only(right: chipSpacing),
              child: ChipItem(
                label: labels[index],
                isSelected: isSelected,
                onTap: () => onChanged(index),
                index: index,
                count: count,
                showRedDot: showRedDot,
                chipPadding: chipPadding,
                chipHeight: chipHeight,
                borderRadius: borderRadius,
                customBorderRadius: customBorderRadius,
                selectedBackgroundColor: selectedBackgroundColor,
                unselectedBackgroundColor: unselectedBackgroundColor,
                selectedTextColor: selectedTextColor,
                unselectedTextColor: unselectedTextColor,
                textStyle: textStyle,
                selectedTextStyle: selectedTextStyle,
                unselectedTextStyle: unselectedTextStyle,
                fontSize: fontSize,
                selectedFontWeight: selectedFontWeight,
                showChipBorder: showChipBorder,
                chipBorderColor: chipBorderColor,
                chipBorderWidth: chipBorderWidth,
                selectedChipBorderColor: selectedChipBorderColor,
                icon: icon,
                customIcon: customIcon,
                iconSize: iconSize,
                iconSpacing: iconSpacing,
                iconAlignment: iconAlignment,
                badge: badge,
                badgeColor: badgeColor,
                badgeTextColor: badgeTextColor,
                badgeTextStyle: badgeTextStyle,
                enabled: isEnabled,
                animationDuration: animationDuration,
                animationCurve: animationCurve,
                onLongPress: onLongPress != null
                    ? () => onLongPress!(index)
                    : null,
                onDoubleTap: onDoubleTap != null
                    ? () => onDoubleTap!(index)
                    : null,
                elevation: elevation,
                selectedElevation: selectedElevation,
                boxShadow: boxShadow,
                selectedBoxShadow: selectedBoxShadow,
                showSelectionIndicator: showSelectionIndicator,
                selectionIndicator: selectionIndicator,
                selectionIndicatorColor: selectionIndicatorColor,
                selectionIndicatorHeight: selectionIndicatorHeight,
              ),
            );
          }),
          ...suffixWidgets,
        ],
      ),
    );

    final content = containerDecoration != null || containerColor != null
        ? Container(
            width: containerWidth,
            height: containerHeight,
            margin: containerMargin,
            decoration:
                containerDecoration ?? BoxDecoration(color: containerColor),
            child: segmentContent,
          )
        : segmentContent;

    return showBorder
        ? Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border:
                  customBorder ??
                  (borderSide != null
                      ? Border(bottom: borderSide!)
                      : Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 2,
                          ),
                        )),
            ),
            child: content,
          )
        : content;
  }
}
