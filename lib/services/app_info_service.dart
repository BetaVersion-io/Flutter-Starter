import 'dart:io' show Platform;

import 'package:betaversion/utils/logger/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

/// Service to provide app information like version and platform
///
/// This service provides access to app metadata that can be used
/// for API headers, analytics, debugging, etc.
class AppInfoService {
  static PackageInfo? _packageInfo;
  static bool _initialized = false;
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Device info fields
  static String _deviceModel = 'Unknown';
  static String _deviceManufacturer = 'Unknown';
  static String _deviceId = 'Unknown';
  static String _osVersion = 'Unknown';

  /// Initialize the app info service
  ///
  /// This should be called once during app startup before making any API calls
  static Future<void> initialize() async {
    if (_initialized) return;

    _packageInfo = await PackageInfo.fromPlatform();
    await _initializeDeviceInfo();
    _initialized = true;
  }

  /// Initialize device-specific information
  static Future<void> _initializeDeviceInfo() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        _deviceModel = webInfo.browserName.name;
        _deviceManufacturer = 'Web';
        _deviceId = 'web-${webInfo.vendor ?? "unknown"}';
        _osVersion = webInfo.platform ?? 'Unknown';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        _deviceModel = androidInfo.model;
        _deviceManufacturer = androidInfo.manufacturer;
        _deviceId = androidInfo.id;
        _osVersion =
            'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        _deviceModel = iosInfo.model;
        _deviceManufacturer = 'Apple';
        _deviceId = iosInfo.identifierForVendor ?? 'Unknown';
        _osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        _deviceModel = macInfo.model;
        _deviceManufacturer = 'Apple';
        _deviceId = macInfo.systemGUID ?? 'Unknown';
        _osVersion = 'macOS ${macInfo.osRelease}';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        _deviceModel = windowsInfo.computerName;
        _deviceManufacturer = 'Microsoft';
        _deviceId = windowsInfo.deviceId;
        _osVersion = 'Windows ${windowsInfo.displayVersion}';
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        _deviceModel = linuxInfo.prettyName;
        _deviceManufacturer = 'Linux';
        _deviceId = linuxInfo.machineId ?? 'Unknown';
        _osVersion = linuxInfo.version ?? 'Unknown';
      }
    } catch (e, stackTrace) {
      // Fallback to defaults if device info fails
      if (kDebugMode) {
        AppLogger.w('Failed to get device info', e, stackTrace);
      }
    }
  }

  /// Get the app version (e.g., "1.0.0")
  static String get appVersion {
    return _packageInfo?.version ?? '0.0.0';
  }

  /// Get the app build number (e.g., "42")
  static String get buildNumber {
    return _packageInfo?.buildNumber ?? '0';
  }

  /// Get the full version string (version+build, e.g., "1.0.0+42")
  static String get fullVersion {
    return '$appVersion+$buildNumber';
  }

  /// Get the app package name/bundle identifier
  static String get packageName {
    return _packageInfo?.packageName ?? 'unknown';
  }

  /// Get the app name
  static String get appName {
    return _packageInfo?.appName ?? 'betaversion';
  }

  /// Get the platform name (Android, iOS, Web, etc.)
  static String get platformName {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isMacOS) {
      return 'MacOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else {
      return 'Unknown';
    }
  }

  /// Get the platform OS version
  static String get platformVersion {
    if (kIsWeb) {
      return 'Web';
    } else {
      return Platform.operatingSystemVersion;
    }
  }

  /// Check if the service is initialized
  static bool get isInitialized => _initialized;

  /// Get a user agent string for API calls
  static String get userAgent {
    return '$appName/$fullVersion ($platformName; $platformVersion)';
  }

  /// Get the device model (e.g., "Pixel 5", "iPhone 12")
  static String get deviceModel {
    return _deviceModel;
  }

  /// Get the device manufacturer (e.g., "Samsung", "Apple")
  static String get deviceManufacturer {
    return _deviceManufacturer;
  }

  /// Get the device ID (unique identifier for the device)
  static String get deviceId {
    return _deviceId;
  }

  /// Get the OS version (e.g., "Android 11 (SDK 30)", "iOS 15.0")
  static String get osVersion {
    return _osVersion;
  }
}
