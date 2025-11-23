import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  final double? iconSize;
  final double? spacing;
  final Color? iconColor;
  final TextStyle? textStyle;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.iconSize,
    this.spacing,
    this.iconColor,
    this.textStyle,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Icon(
          icon,
          size: iconSize ?? 16,
          color: iconColor ?? AppColors.subtitleColor(context),
        ),
        SizedBox(width: spacing ?? 6),
        Text(text, style: textStyle ?? AppTypography.subtitleRegular(context)),
      ],
    );
  }
}

// Alternative name options:
// class IconLabelWidget extends StatelessWidget { ... }
// class LabelWithIconWidget extends StatelessWidget { ... }
// class IconDescriptionWidget extends StatelessWidget { ... }
