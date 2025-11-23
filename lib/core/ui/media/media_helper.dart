import 'dart:developer';

// SOLID Principles Applied:
// S - Single Responsibility: Each class/function has one clear purpose
// O - Open/Closed: Easy to extend with new URL types or asset paths
// L - Liskov Substitution: All validators are interchangeable
// I - Interface Segregation: Separate interfaces for different validation concerns
// D - Dependency Inversion: Depends on abstractions, not concrete implementations

/// Interface for URL validation (Interface Segregation)
abstract class UrlValidator {
  bool isValid(String? url);
}

/// Interface for asset path management (Interface Segregation)
abstract class AssetPathProvider {
  String getAssetPath(String name, AssetType type);
}

/// Interface for media type detection from paths (Interface Segregation)
abstract class MediaPathAnalyzer {
  bool isNetworkPath(String? path);
  bool isAssetPath(String? path);
  String? extractFileExtension(String? path);
  AssetType? detectAssetType(String? path);
}

/// Asset type enumeration
enum AssetType { svg, image, lottie, json, video, audio, document }

/// Enhanced URL validator following SOLID principles (Single Responsibility)
class HttpUrlValidator implements UrlValidator {
  const HttpUrlValidator();

  @override
  bool isValid(String? url) {
    if (url == null || url.isEmpty) return false;

    final trimmedUrl = url.trim();

    try {
      final uri = Uri.parse(trimmedUrl);
      return _validateHttpUri(uri);
    } catch (e) {
      return false;
    }
  }

  bool _validateHttpUri(Uri uri) {
    // Must have valid HTTP/HTTPS scheme
    if (!uri.hasScheme || !_isHttpScheme(uri.scheme)) {
      return false;
    }

    // Must have valid authority (host)
    if (!uri.hasAuthority || uri.host.isEmpty) {
      return false;
    }

    // Validate host format
    return _isValidHost(uri.host);
  }

  bool _isHttpScheme(String scheme) {
    return scheme.toLowerCase() == 'http' || scheme.toLowerCase() == 'https';
  }

  bool _isValidHost(String host) {
    // Allow localhost
    if (host.toLowerCase() == 'localhost') return true;

    // Check for valid domain (must contain at least one dot)
    if (host.contains('.')) return true;

    // Check for valid IP address
    return _isValidIpAddress(host);
  }

  bool _isValidIpAddress(String host) {
    final ipv4Regex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    if (!ipv4Regex.hasMatch(host)) return false;

    final octets = host.split('.');
    return octets.every((octet) {
      final value = int.tryParse(octet);
      return value != null && value >= 0 && value <= 255;
    });
  }
}

/// Protocol-relative URL validator (Open/Closed principle - easily extensible)
class ProtocolRelativeUrlValidator implements UrlValidator {
  const ProtocolRelativeUrlValidator();

  @override
  bool isValid(String? url) {
    if (url == null || url.isEmpty) return false;

    final trimmedUrl = url.trim();

    if (!trimmedUrl.startsWith('//')) return false;

    try {
      // Convert to absolute URL for validation
      final uri = Uri.parse('https:$trimmedUrl');
      return uri.hasAuthority && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

/// Composite URL validator that combines multiple validation strategies
class CompositeUrlValidator implements UrlValidator {
  final List<UrlValidator> _validators;

  const CompositeUrlValidator(this._validators);

  factory CompositeUrlValidator.standard() {
    return const CompositeUrlValidator([
      HttpUrlValidator(),
      ProtocolRelativeUrlValidator(),
    ]);
  }

  @override
  bool isValid(String? url) {
    return _validators.any((validator) => validator.isValid(url));
  }

  /// Add new validator (Open/Closed principle)
  CompositeUrlValidator withValidator(UrlValidator validator) {
    return CompositeUrlValidator([..._validators, validator]);
  }
}

/// Asset path provider for Flutter assets (Single Responsibility)
class FlutterAssetPathProvider implements AssetPathProvider {
  final Map<AssetType, String> _basePaths;

  const FlutterAssetPathProvider({Map<AssetType, String>? basePaths})
    : _basePaths =
          basePaths ??
          const {
            AssetType.svg: 'assets/icons',
            AssetType.image: 'assets/images',
            AssetType.lottie: 'assets/animations',
            AssetType.json: 'assets/data',
            AssetType.video: 'assets/videos',
            AssetType.audio: 'assets/audio',
            AssetType.document: 'assets/documents',
          };

  @override
  String getAssetPath(String name, AssetType type) {
    final basePath = _basePaths[type];
    if (basePath == null) {
      throw ArgumentError('Unsupported asset type: $type');
    }

    final extension = _getDefaultExtension(type);
    final fileName = name.endsWith(extension) ? name : '$name$extension';

    return '$basePath/$fileName';
  }

  String _getDefaultExtension(AssetType type) {
    switch (type) {
      case AssetType.svg:
        return '.svg';
      case AssetType.image:
        return '.png';
      case AssetType.lottie:
        return '.json';
      case AssetType.json:
        return '.json';
      case AssetType.video:
        return '.mp4';
      case AssetType.audio:
        return '.mp3';
      case AssetType.document:
        return '.pdf';
    }
  }

  /// Create custom provider with different base paths
  factory FlutterAssetPathProvider.custom({
    String? iconsPath,
    String? imagesPath,
    String? animationsPath,
  }) {
    final basePaths = <AssetType, String>{
      AssetType.svg: iconsPath ?? 'assets/icons',
      AssetType.image: imagesPath ?? 'assets/images',
      AssetType.lottie: animationsPath ?? 'assets/animations',
    };

    return FlutterAssetPathProvider(basePaths: basePaths);
  }
}

/// Media path analyzer for detecting path types and extracting information
class DefaultMediaPathAnalyzer implements MediaPathAnalyzer {
  final UrlValidator _urlValidator;

  const DefaultMediaPathAnalyzer({UrlValidator? urlValidator})
    : _urlValidator =
          urlValidator ??
          const CompositeUrlValidator([
            HttpUrlValidator(),
            ProtocolRelativeUrlValidator(),
          ]);

  @override
  bool isNetworkPath(String? path) {
    return _urlValidator.isValid(path);
  }

  @override
  bool isAssetPath(String? path) {
    if (path == null || path.isEmpty) return false;

    // Asset paths typically don't have protocols and don't start with /
    return !isNetworkPath(path) && !path.startsWith('/');
  }

  @override
  String? extractFileExtension(String? path) {
    if (path == null || path.isEmpty) return null;

    // Handle URLs with query parameters
    final pathWithoutQuery = path.split('?').first;
    final lastDotIndex = pathWithoutQuery.lastIndexOf('.');

    if (lastDotIndex == -1 || lastDotIndex == pathWithoutQuery.length - 1) {
      return null;
    }

    return pathWithoutQuery.substring(lastDotIndex + 1).toLowerCase();
  }

  @override
  AssetType? detectAssetType(String? path) {
    final extension = extractFileExtension(path);
    if (extension == null) return null;

    switch (extension) {
      case 'svg':
        return AssetType.svg;
      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'gif':
      case 'webp':
      case 'bmp':
        return AssetType.image;
      case 'json':
        // Could be Lottie or data - need additional context
        if (path?.toLowerCase().contains('lottie') == true ||
            path?.toLowerCase().contains('animation') == true) {
          return AssetType.lottie;
        }
        return AssetType.json;
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return AssetType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
        return AssetType.audio;
      case 'pdf':
      case 'doc':
      case 'docx':
        return AssetType.document;
      default:
        return null;
    }
  }
}

/// Main media helper class following SOLID principles
class MediaHelper {
  final UrlValidator _urlValidator;
  final AssetPathProvider _assetPathProvider;
  final MediaPathAnalyzer _pathAnalyzer;

  const MediaHelper({
    UrlValidator? urlValidator,
    AssetPathProvider? assetPathProvider,
    MediaPathAnalyzer? pathAnalyzer,
  }) : _urlValidator =
           urlValidator ??
           const CompositeUrlValidator([
             HttpUrlValidator(),
             ProtocolRelativeUrlValidator(),
           ]),
       _assetPathProvider =
           assetPathProvider ?? const FlutterAssetPathProvider(),
       _pathAnalyzer = pathAnalyzer ?? const DefaultMediaPathAnalyzer();

  /// Factory constructor for default configuration
  factory MediaHelper.standard() => const MediaHelper();

  /// Validate if path is a valid URL
  bool isValidUrl(String? path) => _urlValidator.isValid(path);

  /// Check if path is a network path
  bool isNetworkPath(String? path) => _pathAnalyzer.isNetworkPath(path);

  /// Check if path is an asset path
  bool isAssetPath(String? path) => _pathAnalyzer.isAssetPath(path);

  /// Get asset path for given name and type
  String getAssetPath(String name, AssetType type) =>
      _assetPathProvider.getAssetPath(name, type);

  /// Extract file extension from path
  String? getFileExtension(String? path) =>
      _pathAnalyzer.extractFileExtension(path);

  /// Detect asset type from path
  AssetType? detectAssetType(String? path) =>
      _pathAnalyzer.detectAssetType(path);

  /// Convenience method for SVG assets (backward compatibility)
  String getLocalSvg(String name) => getAssetPath(name, AssetType.svg);

  /// Convenience method for image assets
  String getLocalImage(String name) => getAssetPath(name, AssetType.image);

  /// Convenience method for Lottie animations
  String getLocalLottie(String name) => getAssetPath(name, AssetType.lottie);
}

/// Global instance for backward compatibility
final _defaultMediaHelper = MediaHelper.standard();

/// Global functions for backward compatibility
bool isUrlCorrect(String? path) => _defaultMediaHelper.isValidUrl(path);
String getLocalSvg(String name) => _defaultMediaHelper.getLocalSvg(name);
String getLocalImage(String name) => _defaultMediaHelper.getLocalImage(name);
String getLocalLottie(String name) => _defaultMediaHelper.getLocalLottie(name);

/// Extension methods for convenient usage
extension MediaHelperExtensions on String {
  bool get isValidUrl => _defaultMediaHelper.isValidUrl(this);
  bool get isNetworkPath => _defaultMediaHelper.isNetworkPath(this);
  bool get isAssetPath => _defaultMediaHelper.isAssetPath(this);
  String? get fileExtension => _defaultMediaHelper.getFileExtension(this);
  AssetType? get assetType => _defaultMediaHelper.detectAssetType(this);
}

/// Validation test suite (Single Responsibility)
class MediaHelperTestSuite {
  final MediaHelper _helper;

  const MediaHelperTestSuite([MediaHelper? helper])
    : _helper = helper ?? const MediaHelper();

  /// Run comprehensive validation tests
  void runTests() {
    _testUrlValidation();
    _testAssetPathGeneration();
    _testPathAnalysis();
  }

  void _testUrlValidation() {
    final testCases = <String?, bool>{
      'https://example.com/image.png': true,
      'http://localhost:3000/api': true,
      'https://192.168.1.1/resource': true,
      '//cdn.example.com/image.jpg': true,
      'https://s3.amazonaws.com/bucket/file.svg': true,
      'not-a-url': false,
      'assets/images/logo.png': false,
      '/relative/path.jpg': false,
      '': false,
      null: false,
    };

    log('=== URL Validation Tests ===');
    testCases.forEach((testCase, expected) {
      final result = _helper.isValidUrl(testCase);
      final status = result == expected ? '✅' : '❌';
      log('$status $testCase: $result (expected: $expected)');
    });
  }

  void _testAssetPathGeneration() {
    log('\n=== Asset Path Generation Tests ===');

    final tests = <String, AssetType>{
      'star': AssetType.svg,
      'logo': AssetType.image,
      'loading': AssetType.lottie,
    };

    tests.forEach((name, type) {
      final path = _helper.getAssetPath(name, type);
      log('✅ $name ($type): $path');
    });
  }

  void _testPathAnalysis() {
    log('\n=== Path Analysis Tests ===');

    final testPaths = [
      'https://example.com/image.png',
      'assets/icons/star.svg',
      'animations/loading.json',
      '/absolute/path.jpg',
    ];

    for (final path in testPaths) {
      log('📄 Path: $path');
      log('  - Is Network: ${_helper.isNetworkPath(path)}');
      log('  - Is Asset: ${_helper.isAssetPath(path)}');
      log('  - Extension: ${_helper.getFileExtension(path)}');
      log('  - Asset Type: ${_helper.detectAssetType(path)}');
    }
  }
}
