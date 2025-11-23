import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/services/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// No Internet Interceptor
///
/// This interceptor automatically detects network connectivity errors
/// and navigates the user to the no internet screen.
///
/// The interceptor:
/// 1. Checks for connection errors in DioExceptions
/// 2. Navigates to no internet screen when connectivity issues are detected
/// 3. Uses route push to allow back navigation
/// 4. Logs the error detection in debug mode
///
/// This is useful for global network error handling where you want to
/// block the entire app when there's no internet connection.
///
/// For inline error handling (showing no internet UI within specific widgets),
/// use QueryStateBuilder instead, which automatically detects network errors
/// and shows the NoInternetScreen inline.
class NoInternetInterceptor extends Interceptor {
  /// Creates a no internet interceptor.
  NoInternetInterceptor();

  /// Intercepts error responses to check for network connectivity issues.
  ///
  /// This method is called when an HTTP request fails. It checks for
  /// connection errors and navigates to the no internet screen if detected.
  ///
  /// [err] - The Dio exception that occurred
  /// [handler] - The handler to continue error processing
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _checkNetworkError(err);
    handler.next(err);
  }

  /// Checks if the error is a network connectivity issue.
  ///
  /// If a connection error is detected, navigates the user to the
  /// no internet screen.
  ///
  /// [err] - The DioException to check
  void _checkNetworkError(DioException err) {
    // Check if it's a connection error
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      try {
        if (kDebugMode) {
          print('🌐 No internet detected: Navigating to no internet screen');
        }

        // Navigate to no internet screen (push to allow back navigation)
        NavigationService.pushNamed(RouteConstants.noInternet);
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error during no internet navigation: $e');
        }
      }
    }
  }
}
