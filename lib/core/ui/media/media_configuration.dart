import 'package:flutter/material.dart';

/// Configuration data class (Single Responsibility)
class MediaConfiguration {
  final String? path;
  final String? placeHolderPath;
  final MediaDimensions dimensions;
  final MediaAppearance appearance;
  final MediaLayout layout;
  final MediaBehavior behavior;
  final MediaFallbacks fallbacks;

  const MediaConfiguration({
    this.path,
    this.placeHolderPath,
    required this.dimensions,
    required this.appearance,
    required this.layout,
    required this.behavior,
    required this.fallbacks,
  });
}

/// Media dimensions configuration
class MediaDimensions {
  final double? width;
  final double? height;

  const MediaDimensions({this.width, this.height});
}

/// Media appearance configuration
class MediaAppearance {
  final BoxFit fit;
  final bool isRound;
  final Color? tintColor;
  final Color background;
  final Color borderColor;
  final BorderRadius? borderRadius;
  final BorderRadius? backgroundRadius;
  final BlendMode? blendMode;

  const MediaAppearance({
    this.fit = BoxFit.cover,
    this.isRound = false,
    this.tintColor,
    this.background = Colors.transparent,
    this.borderColor = Colors.transparent,
    this.borderRadius,
    this.backgroundRadius,
    this.blendMode,
  });
}

/// Media layout configuration
class MediaLayout {
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final bool isClickable;
  final Function? onTap;

  const MediaLayout({
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.isClickable = false,
    this.onTap,
  });
}

/// Media behavior configuration
class MediaBehavior {
  final bool isRepeat;
  final String? mediaTypeHint;
  final bool useResizeImage;
  final bool isCached;

  const MediaBehavior({
    this.isRepeat = true,
    this.mediaTypeHint,
    this.useResizeImage = true,
    this.isCached = true,
  });
}

/// Media fallback widgets
class MediaFallbacks {
  final Widget? errorWidget;
  final Widget? placeHolder;

  const MediaFallbacks({this.errorWidget, this.placeHolder});
}
