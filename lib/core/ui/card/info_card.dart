import 'package:flutter/material.dart';
import 'package:betaversion/theme/constants/typography.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.iconData,
    required this.iconColor,
    required this.value,
    required this.label,
    super.key,
    this.iconSize = 24,
    this.valueStyle,
    this.labelStyle,
    this.padding,
    this.spacing = 8,
    this.alignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
  });
  final IconData iconData;
  final Color iconColor;
  final String value;
  final String label;
  final double? iconSize;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;
  final double? spacing;
  final CrossAxisAlignment? alignment;
  final MainAxisSize? mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Row(
        mainAxisSize: mainAxisSize!,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(60),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconData, size: iconSize, color: iconColor),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(value, style: valueStyle ?? AppTypography.bodyMediumBold),
                Text(
                  label,
                  style: labelStyle ?? AppTypography.bodySmallRegular,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
