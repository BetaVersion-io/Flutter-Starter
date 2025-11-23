import 'package:betaversion/core/storage/secure_storage.dart';
import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/services/navigation_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication Interceptor
///
/// This interceptor handles authentication-related HTTP operations:
/// - Automatic Bearer token injection from secure storage
/// - 401 unauthorized error handling with token cleanup
/// - User logout and navigation to landing page
///
/// The interceptor accesses the secure storage to retrieve stored authentication
/// tokens and adds them to the Authorization header of outgoing requests.
///
/// On 401 errors, it:
/// 1. Clears authentication tokens from secure storage
/// 2. Clears user data from local storage
/// 3. Navigates to the landing page
class AuthInterceptor extends Interceptor {
  /// Creates an authentication interceptor with the given Riverpod reference.
  ///
  /// [ref] - The Riverpod reference for accessing other providers
  AuthInterceptor(this.ref);

  /// Reference to the Riverpod container for accessing other providers.
  final Ref ref;

  /// Intercepts outgoing requests to inject authentication tokens.
  ///
  /// This method is called before every HTTP request is sent. It:
  /// 1. Retrieves the stored authentication token from secure storage
  /// 2. Adds it to the Authorization header as a Bearer token
  ///
  /// [options] - The request options to modify
  /// [handler] - The handler to continue the request
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getAuthToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  /// Intercepts error responses to handle authentication failures.
  ///
  /// This method is called when an HTTP request fails. It specifically
  /// handles 401 Unauthorized responses by:
  /// 1. Clearing stored authentication tokens
  /// 2. Clearing user data from local storage
  /// 3. Navigating to the landing page
  ///
  /// [err] - The Dio exception that occurred
  /// [handler] - The handler to continue error processing
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      try {
        // Clear authentication tokens
        await SecureStorage.clearAuthTokens();

        // Navigate to login (replace current route to prevent back navigation)
        NavigationService.goNamed(RouteConstants.login);

        if (kDebugMode) {
          print('🔒 401 Unauthorized: User logged out and redirected to login');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error during 401 logout process: $e');
        }
      }
    }

    handler.next(err);
  }
}
