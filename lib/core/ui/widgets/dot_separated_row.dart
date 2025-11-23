import 'package:betaversion/theme/constants/typography.dart';
import 'package:flutter/material.dart';

class DotSeparatedRow extends StatelessWidget {
  final List<DotSeparatedItem> items;
  final double spacing;
  final TextStyle? dotStyle;

  const DotSeparatedRow({
    super.key,
    required this.items,
    this.spacing = 8,
    this.dotStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final children = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      children.add(
        Text(item.text, style: item.style ?? AppTypography.regular12P),
      );

      if (i < items.length - 1) {
        children.addAll([
          SizedBox(width: spacing),
          Text('•', style: dotStyle ?? AppTypography.regular12P),
          SizedBox(width: spacing),
        ]);
      }
    }

    return Wrap(children: children);
  }
}

class DotSeparatedItem {
  final String text;
  final TextStyle? style;

  const DotSeparatedItem({required this.text, this.style});
}
