import 'package:betaversion/core/ui/media/media_builders.dart';
import 'package:betaversion/core/ui/media/media_configuration.dart';
import 'package:betaversion/core/ui/media/media_interfaces.dart';
import 'package:flutter/material.dart';

class MediaView extends StatelessWidget {
  final MediaConfiguration config;
  final MediaTypeDetector detector;
  final MediaRendererFactory rendererFactory;
  final MediaContainerBuilder containerBuilder;

  const MediaView({
    required this.config,
    super.key,
    MediaTypeDetector? detector,
    MediaRendererFactory? rendererFactory,
    MediaContainerBuilder? containerBuilder,
  }) : detector = detector ?? const DefaultMediaTypeDetector(),
       rendererFactory = rendererFactory ?? const DefaultMediaRendererFactory(),
       containerBuilder =
           containerBuilder ?? const DefaultMediaContainerBuilder();

  /// Factory constructor for backward compatibility
  factory MediaView.universal({
    required String? path,
    Key? key,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    String? placeHolderPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? placeHolder,
    bool isImageRound = false,
    bool isRepeat = true,
    Function? onTap,
    String? mediaTypeEnum,
    Color? tintColor,
    Color background = Colors.transparent,
    Color borderColor = Colors.transparent,
    bool isClickable = false,
    BorderRadius? borderRadius,
    BorderRadius? backgroundRadius,
    bool useResizeImage = true,
    bool isCached = true,
    BlendMode? blendMode,
  }) {
    final config = MediaConfiguration(
      path: path,
      placeHolderPath: placeHolderPath,
      dimensions: MediaDimensions(width: width, height: height),
      appearance: MediaAppearance(
        fit: fit,
        isRound: isImageRound,
        tintColor: tintColor,
        background: background,
        borderColor: borderColor,
        borderRadius: borderRadius,
        backgroundRadius: backgroundRadius,
        blendMode: blendMode,
      ),
      layout: MediaLayout(
        margin: margin,
        padding: padding,
        isClickable: isClickable,
        onTap: onTap,
      ),
      behavior: MediaBehavior(
        isRepeat: isRepeat,
        mediaTypeHint: mediaTypeEnum,
        useResizeImage: useResizeImage,
        isCached: isCached,
      ),
      fallbacks: MediaFallbacks(
        errorWidget: errorWidget,
        placeHolder: placeHolder,
      ),
    );

    return MediaView(key: key, config: config);
  }

  @override
  Widget build(BuildContext context) {
    final mediaType = detector.detectMediaType(
      config.path,
      config.behavior.mediaTypeHint,
    );
    final renderer = rendererFactory.createRenderer(mediaType);
    final mediaWidget = renderer.render(config, context);

    return containerBuilder.buildContainer(config, mediaWidget);
  }
}

// Backward compatibility alias
// typedef UniversalMediaView = MediaView; // Uncomment if needed for compatibility
