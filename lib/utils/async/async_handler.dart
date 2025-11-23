import 'dart:developer' as developer;

/// A utility class for handling async operations with error handling
class AsyncHandler {
  /// Executes a Future with automatic error handling
  ///
  /// [future] - The Future to execute
  /// [fallbackValue] - Value to return when the Future fails (optional)
  /// [onError] - Callback function when an error occurs (optional)
  /// [logError] - Whether to log errors to console (default: true)
  /// [logTag] - Custom tag for logging (default: 'AsyncHandler')
  /// [silentFail] - If true, suppresses error logging (default: false)
  ///
  /// Returns the result of the Future or the fallbackValue if an error occurs
  static Future<T?> handle<T>({
    required Future<T> future,
    T? fallbackValue,
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) async {
    try {
      return await future;
    } catch (error, stackTrace) {
      // Log error if enabled and not silent
      if (logError && !silentFail) {
        developer.log(
          'Error occurred: $error',
          name: logTag,
          error: error,
          stackTrace: stackTrace,
        );
      }

      // Call custom error handler if provided
      onError?.call(error, stackTrace);

      return fallbackValue;
    }
  }

  /// Executes a Future with automatic error handling (non-nullable return)
  ///
  /// Same as handle() but requires a fallbackValue and returns non-nullable T
  static Future<T> handleWithFallback<T>({
    required Future<T> future,
    required T fallbackValue,
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) async {
    try {
      return await future;
    } catch (error, stackTrace) {
      // Log error if enabled and not silent
      if (logError && !silentFail) {
        developer.log(
          'Error occurred: $error',
          name: logTag,
          error: error,
          stackTrace: stackTrace,
        );
      }

      // Call custom error handler if provided
      onError?.call(error, stackTrace);

      return fallbackValue;
    }
  }

  /// Executes multiple Futures concurrently with error handling
  ///
  /// Returns a list with successful results and null for failed ones
  static Future<List<T?>> handleMultiple<T>(
    List<Future<T>> futures, {
    Function(dynamic error, StackTrace stackTrace, int index)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) async {
    final List<T?> results = [];

    for (int i = 0; i < futures.length; i++) {
      final result = await handle<T>(
        future: futures[i],
        onError: (error, stackTrace) => onError?.call(error, stackTrace, i),
        logError: logError,
        logTag: logTag,
        silentFail: silentFail,
      );
      results.add(result);
    }

    return results;
  }

  /// Executes a void Future with error handling
  static Future<bool> handleVoid({
    required Future<void> future,
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) async {
    try {
      await future;
      return true;
    } catch (error, stackTrace) {
      // Log error if enabled and not silent
      if (logError && !silentFail) {
        developer.log(
          'Error occurred: $error',
          name: logTag,
          error: error,
          stackTrace: stackTrace,
        );
      }

      // Call custom error handler if provided
      onError?.call(error, stackTrace);

      return false;
    }
  }
}

/// Extension methods for Future to make async handling more convenient
extension FutureAsyncHandler<T> on Future<T> {
  /// Handle this Future with automatic error handling
  Future<T?> handleAsync({
    T? fallbackValue,
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) {
    return AsyncHandler.handle<T>(
      future: this,
      fallbackValue: fallbackValue,
      onError: onError,
      logError: logError,
      logTag: logTag,
      silentFail: silentFail,
    );
  }

  /// Handle this Future with required fallback value
  Future<T> handleAsyncWithFallback({
    required T fallbackValue,
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) {
    return AsyncHandler.handleWithFallback<T>(
      future: this,
      fallbackValue: fallbackValue,
      onError: onError,
      logError: logError,
      logTag: logTag,
      silentFail: silentFail,
    );
  }
}

/// Extension for void Futures
extension FutureVoidAsyncHandler on Future<void> {
  /// Handle this void Future with automatic error handling
  Future<bool> handleAsync({
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) {
    return AsyncHandler.handleVoid(
      future: this,
      onError: onError,
      logError: logError,
      logTag: logTag,
      silentFail: silentFail,
    );
  }

  /// Handle this void Future with automatic error handling (clearer name to avoid ambiguity)
  Future<bool> handleVoidAsync({
    Function(dynamic error, StackTrace stackTrace)? onError,
    bool logError = true,
    String logTag = 'AsyncHandler',
    bool silentFail = false,
  }) {
    return AsyncHandler.handleVoid(
      future: this,
      onError: onError,
      logError: logError,
      logTag: logTag,
      silentFail: silentFail,
    );
  }
}
