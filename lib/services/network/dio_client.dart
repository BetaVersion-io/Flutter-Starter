/// HTTP Client Configuration
///
/// This library provides the main HTTP client configuration for the betaversion application
/// using Dio. It sets up the base configuration, interceptors, and providers for
/// making API calls throughout the application.
///
/// Key features:
/// - Centralized HTTP client configuration with Riverpod
/// - Automatic authentication token injection
/// - Force update detection via x-force-update header
/// - Brotli compression support for reduced bandwidth
/// - Request/response logging in debug mode
/// - Error handling and 401 unauthorized token cleanup
/// - Retry mechanism for failed requests (currently disabled)
///
/// The client is configured with:
/// - Base URL from environment configuration
/// - Connection and receive timeouts of 15 seconds
/// - JSON content type headers
/// - Compression headers for optimal performance
///
/// Example usage:
/// ```dart
/// final dio = ref.read(dioClientProvider);
/// final response = await dio.get('/endpoint');
/// ```
library;

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:betaversion/config/env_config.dart';
import 'package:betaversion/services/network/interceptors/app_info_interceptor.dart';
import 'package:betaversion/services/network/interceptors/auth_interceptor.dart';
import 'package:betaversion/services/network/interceptors/force_update_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// The complete base API URL combining base URL and version.
/// This is the final URL that will be used as the base for all API requests.
/// Format: {apiBaseUrl}/{apiVersion} (e.g., https://api.example.com/v1)
final baseApiUrl = EnvConfig.fullApiUrl;

/// Riverpod provider for the configured Dio HTTP client.
///
/// This provider creates and configures a Dio instance with all necessary
/// settings including base URL, timeouts, headers, and interceptors.
/// The client is configured with:
/// - Base URL from environment configuration
/// - 15-second connection and receive timeouts
/// - JSON content type and compression headers
/// - Brotli compression transformer
/// - Authentication interceptor for token injection
/// - Pretty logging in debug mode
///
/// Example usage:
/// ```dart
/// final dio = ref.read(dioClientProvider);
/// final response = await dio.get('/users');
/// ```
final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseApiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // COMPRESSION HEADERS:
        'Accept-Encoding': 'gzip, deflate',
      },
    ),
  );

  final options = CacheOptions(
    // A default store is required for interceptor.
    store: MemCacheStore(),
    // Returns a cached response on error for given status codes.
    // Defaults to `[]`.
    hitCacheOnErrorCodes: [500],
    // Allows to return a cached response on network errors (e.g. offline usage).
    // Defaults to `false`.
    hitCacheOnNetworkFailure: true,
    // Overrides any HTTP directive to delete entry past this duration.
    // Useful only when origin server has no cache config or custom behaviour is desired.
    // Defaults to `null`.
    maxStale: const Duration(days: 7),
  );

  // Add interceptors in order of execution
  // 1. App Info - Add app/device headers to every request
  dio.interceptors.add(AppInfoInterceptor());

  // dio.interceptors.add(NoInternetInterceptor());
  // dio.interceptors.add(ForbiddenInterceptor());

  // 2. Auth - Add authentication token and handle 401 errors
  dio.interceptors.add(AuthInterceptor(ref));

  // 3. Force Update - Check for force update header
  dio.interceptors.add(ForceUpdateInterceptor());

  // 4. Cache - Handle response caching
  dio.interceptors.add(DioCacheInterceptor(options: options));

  // 5. Logger - Log requests/responses in debug mode (last to see final request)
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
      ),
    );
  }

  return dio;
});
