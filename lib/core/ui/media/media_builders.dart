import 'package:flutter/material.dart';
import 'package:betaversion/core/ui/media/media_helper.dart';
import 'package:betaversion/core/ui/media/media_configuration.dart';
import 'package:betaversion/core/ui/media/media_interfaces.dart';
import 'package:betaversion/core/ui/media/media_renderers.dart';

/// Default media type detector implementation
class DefaultMediaTypeDetector implements MediaTypeDetector {
  const DefaultMediaTypeDetector();

  @override
  MediaType detectMediaType(String? path, String? typeHint) {
    if (path == null || path.isEmpty) return MediaType.error;

    // Use type hint if provided
    if (typeHint != null && typeHint.isNotEmpty) {
      return _detectFromHint(path, typeHint);
    }

    // Detect from URL/path
    return _detectFromPath(path);
  }

  MediaType _detectFromHint(String path, String hint) {
    final isNetwork = isUrlCorrect(path);
    switch (hint.toUpperCase()) {
      case 'SVG':
        return isNetwork ? MediaType.networkSVG : MediaType.assetSVG;
      case 'LOTTIE':
        return isNetwork ? MediaType.networkLottie : MediaType.assetLottie;
      case 'PNG':
      case 'IMAGE':
        return isNetwork ? MediaType.networkImage : MediaType.assetImage;
      default:
        return MediaType.error;
    }
  }

  MediaType _detectFromPath(String path) {
    final isNetwork = isUrlCorrect(path);
    final lowercasePath = path.toLowerCase();

    if (lowercasePath.contains('.svg')) {
      return isNetwork ? MediaType.networkSVG : MediaType.assetSVG;
    } else if (lowercasePath.contains('.json')) {
      return isNetwork ? MediaType.networkLottie : MediaType.assetLottie;
    } else if (_isImageExtension(lowercasePath)) {
      return isNetwork ? MediaType.networkImage : MediaType.assetImage;
    }

    return MediaType.error;
  }

  bool _isImageExtension(String path) {
    return path.contains('.png') ||
        path.contains('.jpg') ||
        path.contains('.jpeg') ||
        path.contains('.gif') ||
        path.contains('.webp');
  }
}

/// Default media renderer factory (Open/Closed principle)
class DefaultMediaRendererFactory implements MediaRendererFactory {
  const DefaultMediaRendererFactory();

  @override
  MediaRenderer createRenderer(MediaType type) {
    switch (type) {
      case MediaType.networkImage:
        return const NetworkImageRenderer();
      case MediaType.networkSVG:
        return const NetworkSVGRenderer();
      case MediaType.networkLottie:
        return const NetworkLottieRenderer();
      case MediaType.assetImage:
        return const AssetImageRenderer();
      case MediaType.assetSVG:
        return const AssetSVGRenderer();
      case MediaType.assetLottie:
        return const AssetLottieRenderer();
      case MediaType.error:
        return const ErrorRenderer();
    }
  }
}

/// Default container builder (Single Responsibility)
class DefaultMediaContainerBuilder implements MediaContainerBuilder {
  const DefaultMediaContainerBuilder();

  @override
  Widget buildContainer(MediaConfiguration config, Widget child) {
    final containerWidget = Container(
      width: config.dimensions.width,
      height: config.dimensions.height,
      margin: config.layout.margin,
      decoration: _buildDecoration(config),
      child: Padding(
        padding: config.layout.padding,
        child: ClipRRect(
          borderRadius: _buildBorderRadius(config),
          child: child,
        ),
      ),
    );

    return config.layout.isClickable
        ? InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: () => config.layout.onTap?.call(),
            child: containerWidget,
          )
        : containerWidget;
  }

  BoxDecoration _buildDecoration(MediaConfiguration config) {
    return config.appearance.isRound
        ? BoxDecoration(
            shape: BoxShape.circle,
            color: config.appearance.background,
            border: Border.all(color: config.appearance.borderColor),
          )
        : BoxDecoration(
            color: config.appearance.background,
            borderRadius: config.appearance.backgroundRadius,
          );
  }

  BorderRadius _buildBorderRadius(MediaConfiguration config) {
    return config.appearance.borderRadius ??
        BorderRadius.all(
          config.appearance.isRound
              ? Radius.circular((config.dimensions.height ?? 2) / 2)
              : const Radius.circular(0),
        );
  }
}
