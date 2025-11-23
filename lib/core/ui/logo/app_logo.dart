import 'package:flutter/material.dart';
import 'package:betaversion/core/ui/icons/app_icon.dart';
import 'package:betaversion/theme/extensions/extension.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.text = 'betaversion',
    this.logoSize = 32,
    this.spacing = 8,
    this.textStyle,
    this.fontSize = 28,
    this.fontWeight = FontWeight.w700,
    this.letterSpacing = -0.5,
    this.mainAxisSize = MainAxisSize.min,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.isVertical = false,
    this.color,
  });
  final String text;
  final double? logoSize;
  final double spacing;
  final TextStyle? textStyle;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final bool isVertical;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultColor = theme.isDark
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.primary;

    final textWidget = Text(
      text,
      style:
          textStyle ??
          TextStyle(
            color: color ?? defaultColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            letterSpacing: letterSpacing,
          ),
    );

    final spacingWidget = SizedBox(
      width: isVertical ? 0 : spacing,
      height: isVertical ? spacing : 0,
    );

    return Flex(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      children: [
        AppIcon(size: logoSize, color: color),
        spacingWidget,
        textWidget,
      ],
    );
  }
}
