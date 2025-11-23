import 'package:betaversion/services/app_info_service.dart';
import 'package:dio/dio.dart';

/// App Info Interceptor
///
/// This interceptor automatically adds application and device information
/// to all outgoing HTTP requests. This information helps the backend:
/// - Track app versions and platforms
/// - Determine if force updates are needed
/// - Collect device analytics
/// - Debug platform-specific issues
///
/// Headers added:
/// - X-App-Version: App version (e.g., "1.0.0")
/// - X-App-Build: Build number (e.g., "123")
/// - X-Platform: Platform name (e.g., "Android", "iOS")
/// - User-Agent: Full user agent string
/// - X-Device-Model: Device model (e.g., "iPhone 14", "Pixel 7")
/// - X-Device-Manufacturer: Device manufacturer (e.g., "Apple", "Google")
/// - X-Device-ID: Unique device identifier
/// - X-OS-Version: Operating system version
class AppInfoInterceptor extends Interceptor {
  /// Creates an app info interceptor.
  AppInfoInterceptor();

  /// Intercepts outgoing requests to add app and device information.
  ///
  /// This method is called before every HTTP request is sent. It adds
  /// comprehensive app and device information to the request headers.
  ///
  /// [options] - The request options to modify
  /// [handler] - The handler to continue the request
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add app version and platform to headers
    options.headers['X-App-Version'] = AppInfoService.appVersion;
    options.headers['X-App-Build'] = AppInfoService.buildNumber;
    options.headers['X-Platform'] = AppInfoService.platformName;
    options.headers['User-Agent'] = AppInfoService.userAgent;

    // Add device info to headers
    options.headers['X-Device-Model'] = AppInfoService.deviceModel;
    options.headers['X-Device-Manufacturer'] =
        AppInfoService.deviceManufacturer;
    options.headers['X-Device-ID'] = AppInfoService.deviceId;
    options.headers['X-OS-Version'] = AppInfoService.osVersion;

    handler.next(options);
  }
}
