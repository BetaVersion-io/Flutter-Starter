import 'package:flutter/material.dart';
import 'package:betaversion/theme/constants/sizes.dart';

/// A reusable container with colored border and background
///
/// Takes a color and applies it to both the border and background.
/// The background uses the color with reduced opacity (alpha).
class ColoredBorderContainer extends StatelessWidget {
  const ColoredBorderContainer({
    required this.child,
    required this.color,
    super.key,
    this.backgroundOpacity = 0.1,
    this.padding,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.width,
  });
  final Widget child;
  final Color color;
  final double backgroundOpacity;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double borderWidth;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: color.withAlpha((backgroundOpacity * 255).round()),
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.cardRadiusMd,
        ),
        border: Border.all(color: color, width: borderWidth),
      ),
      child: child,
    );
  }
}
