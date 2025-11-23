import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/services/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Force Update Interceptor
///
/// This interceptor automatically detects force update signals from the backend
/// and navigates the user to the force update screen.
///
/// The backend should send the `x-force-update` header in API responses when
/// a force update is required:
/// ```
/// x-force-update: true
/// ```
///
/// The interceptor:
/// 1. Checks both successful responses and error responses for the header
/// 2. Navigates to force update screen if header value is "true" (case-insensitive)
/// 3. Uses route replacement to prevent back navigation
/// 4. Logs the force update detection in debug mode
///
/// Example backend response:
/// ```http
/// HTTP/1.1 200 OK
/// Content-Type: application/json
/// x-force-update: true
///
/// {"data": "..."}
/// ```
///
/// The user will be automatically redirected to the force update screen,
/// where they can update the app through the appropriate app store.
class ForceUpdateInterceptor extends Interceptor {
  /// Creates a force update interceptor.
  ForceUpdateInterceptor();

  /// Intercepts successful responses to check for force update header.
  ///
  /// This method is called when an HTTP request succeeds. It checks for
  /// the 'x-force-update' header in the response and navigates to the
  /// force update screen if the header value is 'true'.
  ///
  /// [response] - The successful response
  /// [handler] - The handler to continue response processing
  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _checkForceUpdate(response.headers);
    handler.next(response);
  }

  /// Intercepts error responses to check for force update header.
  ///
  /// This method is called when an HTTP request fails. It checks for
  /// the 'x-force-update' header even in error responses to ensure
  /// force updates are applied regardless of request success.
  ///
  /// [err] - The Dio exception that occurred
  /// [handler] - The handler to continue error processing
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.headers != null) {
      _checkForceUpdate(err.response!.headers);
    }

    handler.next(err);
  }

  /// Checks the response headers for force update signal.
  ///
  /// If the 'x-force-update' header is present and set to 'true'
  /// (case-insensitive), navigates the user to the force update screen.
  ///
  /// [headers] - The response headers to check
  void _checkForceUpdate(Headers headers) {
    final forceUpdateHeader = headers.value('x-force-update');

    if (forceUpdateHeader != null &&
        forceUpdateHeader.toLowerCase() == 'true') {
      try {
        // if (kDebugMode) {
        //   print('🔄 Force update detected: Navigating to force update screen');
        // }

        // Navigate to force update screen (replace to prevent back navigation)
        NavigationService.replaceNamed(RouteConstants.forceUpdate);
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error during force update navigation: $e');
        }
      }
    }
  }
}
