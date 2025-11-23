import 'package:betaversion/core/ui/shimmer/card_shimmer.dart';
import 'package:betaversion/core/ui/shimmer/chip_shimmer.dart';
import 'package:betaversion/theme/constants/sizes.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:flutter/material.dart';

/// Common loading widget with filter chips and content list
class FilterContentShimmer extends StatelessWidget {
  final int filterCount;
  final double filterWidth;
  final int contentItemCount;

  const FilterContentShimmer({
    super.key,
    this.filterCount = 3,
    this.filterWidth = 100,
    this.contentItemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.sm,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter Section
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: ChipGroupShimmerVariants.equalWidth(
            itemCount: filterCount,
            width: filterWidth,
          ),
        ),

        // Content Section
        CardShimmerList(itemCount: contentItemCount).expanded(),
      ],
    );
  }
}
