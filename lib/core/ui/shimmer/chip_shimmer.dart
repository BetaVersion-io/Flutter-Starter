import 'package:betaversion/core/ui/shimmer/common_shimmer.dart';
import 'package:flutter/material.dart';

class ChipGroupShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;
  final double spacing;
  final double height;
  final List<double>? customWidths;
  final BorderRadius? borderRadius;
  final Color? shimmerColor;
  final Duration? duration;
  final double? colorOpacity;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const ChipGroupShimmer({
    super.key,
    this.itemCount = 3,
    this.padding = const EdgeInsets.all(16.0),
    this.spacing = 12.0,
    this.height = 32.0,
    this.customWidths,
    this.borderRadius,
    this.shimmerColor,
    this.duration,
    this.colorOpacity,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: _buildShimmerItems(),
      ),
    );
  }

  List<Widget> _buildShimmerItems() {
    final List<Widget> items = [];

    for (int i = 0; i < itemCount; i++) {
      // Add shimmer item
      items.add(
        CommonShimmerShapes.rectangle(
          height: height,
          width: _getItemWidth(i),
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          color: shimmerColor,
          duration: duration,
          colorOpacity: colorOpacity,
        ),
      );

      // Add spacing (except for last item)
      if (i < itemCount - 1) {
        items.add(SizedBox(width: spacing));
      }
    }

    return items;
  }

  double _getItemWidth(int index) {
    if (customWidths != null && index < customWidths!.length) {
      return customWidths![index];
    }

    // Default width progression for realistic filter appearance
    final defaultWidths = [80.0, 100.0, 110.0, 90.0, 95.0];

    if (index < defaultWidths.length) {
      return defaultWidths[index];
    }

    // For items beyond default, use a calculated width
    return 80.0 + (index % 3) * 10.0;
  }
}

// Specialized variants for common use cases
class ChipGroupShimmerVariants {
  /// Standard filter shimmer with 4 items (All, Attempted, Unattempted, Paused)
  static Widget standard({
    EdgeInsets? padding,
    double? spacing,
    double? height,
  }) {
    return ChipGroupShimmer(
      itemCount: 4,
      customWidths: const [
        60,
        90,
        110,
        70,
      ], // All, Attempted, Unattempted, Paused
      padding: padding ?? const EdgeInsets.all(16.0),
      spacing: spacing ?? 12.0,
      height: height ?? 32.0,
    );
  }

  /// Simple 3-item filter shimmer
  static Widget simple({EdgeInsets? padding, double? spacing, double? height}) {
    return ChipGroupShimmer(
      itemCount: 3,
      customWidths: const [60, 80, 90], // All, Active, Inactive
      padding: padding ?? const EdgeInsets.all(16.0),
      spacing: spacing ?? 12.0,
      height: height ?? 32.0,
    );
  }

  /// Compact filter shimmer with smaller padding
  static Widget compact({int? itemCount, List<double>? customWidths}) {
    return ChipGroupShimmer(
      itemCount: itemCount ?? 3,
      customWidths: customWidths ?? const [50, 70, 80],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      spacing: 8.0,
      height: 28.0,
    );
  }

  /// Wide filter shimmer for longer filter names
  static Widget wide({int? itemCount}) {
    return ChipGroupShimmer(
      itemCount: itemCount ?? 3,
      customWidths: const [100, 120, 140],
      padding: const EdgeInsets.all(16.0),
      spacing: 16.0,
      height: 36.0,
    );
  }

  /// Centered filter shimmer
  static Widget centered({int? itemCount, List<double>? customWidths}) {
    return ChipGroupShimmer(
      itemCount: itemCount ?? 3,
      customWidths: customWidths ?? const [70, 90, 100],
      mainAxisAlignment: MainAxisAlignment.center,
      padding: const EdgeInsets.all(16.0),
    );
  }

  /// Equal width filter shimmer
  static Widget equalWidth({
    required int itemCount,
    double width = 80.0,
    EdgeInsets? padding,
  }) {
    return ChipGroupShimmer(
      itemCount: itemCount,
      customWidths: List.filled(itemCount, width),
      padding: padding ?? const EdgeInsets.all(16.0),
    );
  }
}

// Extension for easier usage with specific filter types
extension ChipGroupShimmerExtension on ChipGroupShimmer {
  /// Create shimmer for QBank filters (All, Saved QBank)
  static Widget qbankFilters() {
    return ChipGroupShimmer(
      itemCount: 2,
      customWidths: const [50, 100], // "All", "Saved QBank"
      padding: const EdgeInsets.all(16.0),
    );
  }

  /// Create shimmer for Test filters (All, Attempted, Unattempted, Paused)
  static Widget FilterOptions() {
    return ChipGroupShimmerVariants.standard();
  }

  /// Create shimmer for Video filters
  static Widget videoFilters() {
    return ChipGroupShimmer(
      itemCount: 3,
      customWidths: const [50, 80, 90], // "All", "Watched", "Unwatched"
      padding: const EdgeInsets.all(16.0),
    );
  }
}

// Usage examples in comments:
/*
// Basic usage
ChipGroupShimmer()

// Custom configuration
ChipGroupShimmer(
  itemCount: 4,
  customWidths: [60, 90, 110, 70],
  padding: EdgeInsets.symmetric(horizontal: 20),
  spacing: 16,
  height: 36,
)

// Using variants
ChipGroupShimmerVariants.standard()
ChipGroupShimmerVariants.compact(itemCount: 2)
ChipGroupShimmerVariants.centered()

// Using extensions
ChipGroupShimmerExtension.qbankFilters()
ChipGroupShimmerExtension.FilterOptions()
*/
