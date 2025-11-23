/// API Exception Handling
///
/// This library provides custom exception classes and utilities for handling
/// API-related errors in the betaversion application. It standardizes error handling
/// across all API calls and provides meaningful error messages to the UI layer.
///
/// The main class [ApiException] wraps network and server errors into a
/// consistent format that can be easily handled by the presentation layer.
/// It includes support for HTTP status codes and user-friendly error messages.
///
/// Key features:
/// - Standardized error handling across all API calls
/// - HTTP status code preservation
/// - User-friendly error message extraction
/// - Integration with Dio HTTP client error handling
library;

import 'package:dio/dio.dart';

/// Custom exception class for API-related errors.
///
/// This class provides a standardized way to handle and represent errors
/// that occur during API calls. It encapsulates both the error message
/// and optional HTTP status code for comprehensive error information.
///
/// The exception can be created directly or constructed from a [DioException]
/// using the factory constructor [ApiException.fromDioError].
///
/// Example usage:
/// ```dart
/// try {
///   await apiCall();
/// } on DioException catch (e) {
///   throw ApiException.fromDioError(e);
/// }
/// ```
class ApiException implements Exception {
  /// Creates an API exception with the given message and optional status code.
  ///
  /// [message] - A descriptive error message for the exception
  /// [statusCode] - Optional HTTP status code associated with the error
  ApiException(this.message, [this.statusCode])
    : _isNetworkConnectivityError = false;

  /// Private constructor for creating exceptions with network error flag
  ApiException._(
    this.message,
    this.statusCode,
    this._isNetworkConnectivityError,
  );

  /// Creates an API exception from a Dio HTTP client exception.
  ///
  /// This factory constructor converts various types of [DioException]
  /// into user-friendly [ApiException] instances. It handles different
  /// error scenarios and extracts appropriate error messages.
  ///
  /// Supported error types:
  /// - Connection timeout: Returns a timeout-specific message with 408 status
  /// - Bad response: Extracts error message from server response
  /// - Other errors: Returns a generic network error message
  ///
  /// [e] - The DioException to convert
  ///
  /// Returns an [ApiException] with appropriate message and status code.
  factory ApiException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException._('Connection timeout', 408, true);
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException._('Request timeout', 408, true);
      case DioExceptionType.connectionError:
        return ApiException._('No internet connection', null, true);
      case DioExceptionType.badResponse:
        return ApiException._(
          e.response?.data['message'] ?? 'Server error',
          e.response?.statusCode,
          false,
        );
      case DioExceptionType.cancel:
        return ApiException._('Request cancelled', null, false);
      case DioExceptionType.badCertificate:
        return ApiException._('Certificate error', null, false);
      default:
        return ApiException._('An error occurred: ${e.message}', null, false);
    }
  }

  /// The human-readable error message.
  ///
  /// This message should be suitable for display to end users and
  /// provide clear information about what went wrong.
  final String message;

  /// The HTTP status code associated with the error, if available.
  ///
  /// This is null for client-side errors like network connectivity issues.
  /// For server responses, this contains the HTTP status code (e.g., 404, 500).
  final int? statusCode;

  /// Internal flag to track if this is a network connectivity error
  final bool _isNetworkConnectivityError;

  /// Checks if this exception is a network connectivity error.
  ///
  /// Returns true only for actual network connectivity issues:
  /// - No internet connection
  /// - Connection timeout
  /// - Request timeout (send/receive)
  ///
  /// Returns false for all other errors including server errors,
  /// validation errors, cancelled requests, certificate errors, etc.
  bool get isNetworkError => _isNetworkConnectivityError;

  /// Checks if this exception is a forbidden (403) error
  ///
  /// Returns true if the status code is 403, indicating the user
  /// doesn't have permission to access the requested resource.
  bool get isForbidden {
    return statusCode == 403;
  }
}
