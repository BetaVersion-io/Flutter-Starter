import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Generic reusable badge widget with optional leading indicator dot
///
/// Displays a colored badge with text and optional circular indicator
/// Can be used for status badges, labels, tags, etc.
class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool showIndicator;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.showIndicator = false,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(borderRadius ?? 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIndicator) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const Gap(6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 12,
              fontWeight: fontWeight ?? FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
