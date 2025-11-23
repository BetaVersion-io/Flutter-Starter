import 'package:flutter/material.dart';
import 'package:betaversion/theme/constants/sizes.dart';

// Generic reusable list widget
class CommonItemList<T> extends StatelessWidget {
  const CommonItemList({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.padding,
    this.itemSpacing = 4,
    this.physics,
    this.shrinkWrap = false,
  });
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final double itemSpacing;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: itemSpacing),
      itemBuilder: (context, index) {
        final item = items[index];
        return itemBuilder(item, index);
      },
    );
  }
}
