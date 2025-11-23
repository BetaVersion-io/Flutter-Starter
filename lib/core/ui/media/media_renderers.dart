import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/core/ui/media/media_configuration.dart';
import 'package:betaversion/core/ui/media/media_interfaces.dart';
import 'package:betaversion/core/ui/media/media_view.dart';

/// Network image renderer (Single Responsibility)
class NetworkImageRenderer implements MediaRenderer {
  const NetworkImageRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);

    return config.behavior.isCached
        ? CachedNetworkImage(
            imageUrl: config.path ?? '',
            width: config.dimensions.width,
            height: config.dimensions.height,
            fit: config.appearance.fit,
            memCacheHeight: _calculateCacheSize(
              config.dimensions.height,
              config.behavior.useResizeImage,
            ),
            memCacheWidth: _calculateCacheSize(
              config.dimensions.width,
              config.behavior.useResizeImage,
            ),
            maxHeightDiskCache: _calculateCacheSize(
              config.dimensions.height,
              config.behavior.useResizeImage,
            ),
            maxWidthDiskCache: _calculateCacheSize(
              config.dimensions.width,
              config.behavior.useResizeImage,
            ),
            errorWidget: (context, url, error) => fallbackBuilder.buildError(),
            placeholder: (context, url) => fallbackBuilder.buildPlaceholder(),
          )
        : Image.network(
            config.path ?? '',
            width: config.dimensions.width,
            height: config.dimensions.height,
            fit: config.appearance.fit,
            cacheHeight: _calculateCacheSize(
              config.dimensions.height,
              config.behavior.useResizeImage,
            ),
            cacheWidth: _calculateCacheSize(
              config.dimensions.width,
              config.behavior.useResizeImage,
            ),
            headers: const {
              'Connection': 'Keep-Alive',
              'Keep-Alive': 'timeout=5, max=1000',
            },
            errorBuilder: (context, error, stackTrace) =>
                fallbackBuilder.buildError(),
            loadingBuilder: (context, child, loadingProgress) =>
                loadingProgress == null
                ? child
                : fallbackBuilder.buildPlaceholder(),
          );
  }

  int? _calculateCacheSize(double? dimension, bool useResize) {
    return useResize && dimension != null ? (dimension * 2000).toInt() : null;
  }
}

/// Network SVG renderer (Single Responsibility)
class NetworkSVGRenderer implements MediaRenderer {
  const NetworkSVGRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);

    return SvgPicture.network(
      config.path ?? '',
      width: config.dimensions.width,
      height: config.dimensions.height,
      fit: config.appearance.fit,
      colorFilter: config.appearance.tintColor != null
          ? ColorFilter.mode(
              config.appearance.tintColor!,
              config.appearance.blendMode ?? BlendMode.srcIn,
            )
          : null,
      placeholderBuilder: (context) => fallbackBuilder.buildPlaceholder(),
    );
  }
}

/// Asset image renderer (Single Responsibility)
class AssetImageRenderer implements MediaRenderer {
  const AssetImageRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);

    return Image.asset(
      config.path ?? '',
      width: config.dimensions.width,
      height: config.dimensions.height,
      fit: config.appearance.fit,
      errorBuilder: (context, error, stackTrace) =>
          fallbackBuilder.buildError(),
    );
  }
}

/// Asset SVG renderer (Single Responsibility)
class AssetSVGRenderer implements MediaRenderer {
  const AssetSVGRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);

    return SvgPicture.asset(
      config.path ?? '',
      width: config.dimensions.width,
      height: config.dimensions.height,
      fit: config.appearance.fit,
      colorFilter: config.appearance.tintColor != null
          ? ColorFilter.mode(config.appearance.tintColor!, BlendMode.srcIn)
          : null,
      placeholderBuilder: (context) => fallbackBuilder.buildPlaceholder(),
    );
  }
}

/// Network Lottie renderer (Single Responsibility)
class NetworkLottieRenderer implements MediaRenderer {
  const NetworkLottieRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);
    // TODO: Implement Lottie.network when available
    return fallbackBuilder.buildPlaceholder();
  }
}

/// Asset Lottie renderer (Single Responsibility)
class AssetLottieRenderer implements MediaRenderer {
  const AssetLottieRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);
    // TODO: Implement Lottie.asset when available
    return fallbackBuilder.buildPlaceholder();
  }
}

/// Error renderer (Single Responsibility)
class ErrorRenderer implements MediaRenderer {
  const ErrorRenderer();

  @override
  Widget render(MediaConfiguration config, BuildContext context) {
    final fallbackBuilder = FallbackWidgetBuilder(config);
    return fallbackBuilder.buildError();
  }
}

/// Fallback widget builder (Single Responsibility)
class FallbackWidgetBuilder {
  const FallbackWidgetBuilder(this.config);
  final MediaConfiguration config;

  Widget buildPlaceholder() {
    if (config.placeHolderPath != null) {
      return MediaView.universal(
        path: config.placeHolderPath,
        width: config.dimensions.width,
        height: config.dimensions.height,
        fit: config.appearance.fit,
      );
    }

    return config.fallbacks.placeHolder ?? _buildDefaultPlaceholder();
  }

  Widget buildError() {
    if (config.placeHolderPath != null) {
      return MediaView.universal(
        path: config.placeHolderPath,
        width: config.dimensions.width,
        height: config.dimensions.height,
        fit: config.appearance.fit,
      );
    }

    return config.fallbacks.errorWidget ?? _buildDefaultError();
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      height: config.dimensions.height ?? 100,
      width: config.dimensions.width ?? 100,
      color: AppColors.grey50,
    );
  }

  Widget _buildDefaultError() {
    return Container(
      height: config.dimensions.height ?? 100,
      width: config.dimensions.width ?? 100,
      color: AppColors.grey600,
    );
  }
}
