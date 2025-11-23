import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/services/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

/// Forbidden Interceptor (403)
///
/// This interceptor automatically detects 403 Forbidden responses
/// and navigates the user to the forbidden screen.
///
/// The interceptor:
/// 1. Checks for 403 status code in DioExceptions
/// 2. Navigates to forbidden screen when access is denied
/// 3. Uses route push to allow back navigation
/// 4. Logs the error detection in debug mode
///
/// Common 403 scenarios:
/// - User doesn't have permission to access a resource
/// - Account has been suspended or restricted
/// - IP address is blocked
/// - Access is denied for policy reasons
///
/// This is useful for global access control handling where you want to
/// inform users they don't have permission to access certain features.
///
/// For inline error handling (showing forbidden UI within specific widgets),
/// use QueryStateBuilder instead, which automatically detects forbidden errors
/// and shows appropriate UI inline.
class ForbiddenInterceptor extends Interceptor {
  /// Creates a forbidden interceptor.
  ForbiddenInterceptor();

  /// Intercepts error responses to check for 403 Forbidden status.
  ///
  /// This method is called when an HTTP request fails. It checks for
  /// 403 status codes and navigates to the forbidden screen if detected.
  ///
  /// [err] - The Dio exception that occurred
  /// [handler] - The handler to continue error processing
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _checkForbiddenError(err);
    handler.next(err);
  }

  /// Checks if the error is a 403 Forbidden response.
  ///
  /// If a 403 error is detected, navigates the user to the
  /// forbidden screen.
  ///
  /// [err] - The DioException to check
  void _checkForbiddenError(DioException err) {
    // Check if it's a 403 Forbidden error
    if (err.response?.statusCode == 403) {
      try {
        if (kDebugMode) {
          print('🚫 403 Forbidden detected: Navigating to forbidden screen');
        }

        // Navigate to forbidden screen (push to allow back navigation)
        NavigationService.pushNamed(RouteConstants.forbidden);
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error during forbidden navigation: $e');
        }
      }
    }
  }
}
