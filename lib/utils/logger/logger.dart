import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static late Logger _logger;

  static void init() {
    _logger = Logger(
      filter: _AppLogFilter(),
      printer: PrettyPrinter(
        lineLength: 100, // Width of the output
        dateTimeFormat: DateTimeFormat
            .onlyTime, // Should each log print contain a timestamp
      ),
      output: _AppLogOutput(),
    );
  }

  // Debug logs (verbose information)
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  // Info logs (general information)
  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  // Warning logs
  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  // Error logs
  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Fatal logs (very serious errors)
  static void f(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  // Network specific logs
  static void network(String message, [dynamic data]) {
    _logger.i('🌐 NETWORK: $message', error: data);
  }

  // Navigation specific logs
  static void navigation(String message, [dynamic data]) {
    _logger.i('🧭 NAVIGATION: $message', error: data);
  }

  // API specific logs
  static void api(String message, [dynamic data]) {
    _logger.i('📡 API: $message', error: data);
  }

  // UI specific logs
  static void ui(String message, [dynamic data]) {
    _logger.d('🎨 UI: $message', error: data);
  }

  // Database specific logs
  static void db(String message, [dynamic data]) {
    _logger.i('💾 DATABASE: $message', error: data);
  }

  // Auth specific logs
  static void auth(String message, [dynamic data]) {
    _logger.i('🔐 AUTH: $message', error: data);
  }

  // Payment specific logs
  static void payment(String message, [dynamic data]) {
    _logger.i('💳 PAYMENT: $message', error: data);
  }
}

// Custom log filter to only show logs in debug mode
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return kDebugMode;
  }
}

// Custom log output
class _AppLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      if (kDebugMode) {
        // ignore: avoid_print
        print(line);
      }
    }
  }
}
