import 'package:betaversion/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CommonShimmer extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Color? color;
  final double colorOpacity;
  final BorderRadius? borderRadius;

  const CommonShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.color,
    this.colorOpacity = 0.3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = DeviceUtils.isDarkMode(context);
    final shimmerColor =
        color ??
        (isDark
            ? Theme.of(context).colorScheme.onSurface.withAlpha(20)
            : Theme.of(context).shadowColor);
    Widget shimmerWidget = Shimmer(
      duration: duration,
      color: shimmerColor,
      colorOpacity: colorOpacity,
      child: child,
    );

    // If borderRadius is provided, wrap with ClipRRect
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: shimmerWidget);
    }

    return shimmerWidget;
  }
}

// Extension for common shimmer shapes
extension CommonShimmerShapes on CommonShimmer {
  static Widget rectangle({
    required double height,
    double? width,
    BorderRadius? borderRadius,
    Color? color,
    Duration? duration,
    double? colorOpacity,
  }) {
    return CommonShimmer(
      borderRadius: borderRadius,
      color: color,
      duration: duration ?? const Duration(seconds: 2),
      colorOpacity: colorOpacity ?? 0.3,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300]!.withAlpha(30),
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }

  static Widget circle({
    required double size,
    Color? color,
    Duration? duration,
    double? colorOpacity,
  }) {
    return CommonShimmer(
      borderRadius: BorderRadius.circular(size / 2),
      color: color,
      duration: duration ?? const Duration(seconds: 2),
      colorOpacity: colorOpacity ?? 0.3,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300]!.withAlpha(30),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  static Widget line({
    required double width,
    double height = 14,
    BorderRadius? borderRadius,
    Color? color,
    Duration? duration,
    double? colorOpacity,
  }) {
    return CommonShimmer(
      borderRadius: borderRadius ?? BorderRadius.circular(4),
      color: color,
      duration: duration ?? const Duration(seconds: 2),
      colorOpacity: colorOpacity ?? 0.3,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? Colors.grey[300]!.withAlpha(30),
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}
