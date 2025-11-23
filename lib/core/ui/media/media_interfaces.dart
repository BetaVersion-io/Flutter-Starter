import 'package:flutter/material.dart';
import 'media_configuration.dart';

/// Media type enumeration
enum MediaType {
  networkImage,
  networkSVG,
  networkLottie,
  assetImage,
  assetSVG,
  assetLottie,
  error,
}

/// Interface for media type detection (Interface Segregation)
abstract class MediaTypeDetector {
  MediaType detectMediaType(String? path, String? typeHint);
}

/// Interface for media rendering (Interface Segregation)
abstract class MediaRenderer {
  Widget render(MediaConfiguration config, BuildContext context);
}

/// Interface for media renderer factory (Open/Closed, Dependency Inversion)
abstract class MediaRendererFactory {
  MediaRenderer createRenderer(MediaType type);
}

/// Interface for container building (Interface Segregation)
abstract class MediaContainerBuilder {
  Widget buildContainer(MediaConfiguration config, Widget child);
}
