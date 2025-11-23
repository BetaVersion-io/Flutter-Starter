// Example usage of AppLogger - Remove this file after understanding
import 'package:betaversion/utils/logger/logger.dart';

class LoggerExamples {
  void demonstrateLogging() {
    // Basic logging levels
    AppLogger.d('Debug message for development');
    AppLogger.i('General information message');
    AppLogger.w('Warning about something');
    AppLogger.e('Error occurred!');
    AppLogger.f('Fatal error - app crash!');

    // Specialized logging with emojis
    AppLogger.network('Making HTTP request to /api/users');
    AppLogger.api('User login successful', {
      'userId': 123,
      'email': 'user@example.com',
    });
    AppLogger.navigation('Navigating to HomeScreen');
    AppLogger.ui('Button clicked - Submit Form');
    AppLogger.db('User data saved to database');
    AppLogger.auth('User authenticated successfully');
    AppLogger.payment(r'Payment processed: $29.99');

    // Logging with error objects
    try {
      throw Exception('Something went wrong!');
    } catch (e, stackTrace) {
      AppLogger.e('Caught an exception', e, stackTrace);
    }

    // Logging complex data
    AppLogger.api('API Response received', {
      'endpoint': '/api/users',
      'status': 200,
      'data': {
        'users': [
          {'id': 1, 'name': 'John'},
          {'id': 2, 'name': 'Jane'},
        ],
        'total': 2,
      },
    });
  }

  void userActions() {
    // User interaction logging
    AppLogger.ui('User tapped login button');
    AppLogger.auth('Starting authentication process');

    // Navigation logging
    AppLogger.navigation('Pushing route: /login');
    AppLogger.navigation('Popping route: /home');

    // Form submission
    AppLogger.ui('Form validation started');
    AppLogger.ui('Form validation passed');
    AppLogger.api('Submitting form data');
  }

  void apiCalls() {
    // API lifecycle logging
    AppLogger.network('Initializing API client');
    AppLogger.api('🔄 POST /api/auth/login');
    AppLogger.api('✅ Login successful - token received');

    AppLogger.api('🔄 GET /api/user/profile');
    AppLogger.api('✅ Profile data loaded');

    // Error scenarios
    AppLogger.api('❌ Failed to load data - 404 Not Found');
    AppLogger.api('⚠️ Retrying request in 3 seconds...');
  }

  void databaseOperations() {
    // Database logging
    AppLogger.db('Opening database connection');
    AppLogger.db('Executing query: SELECT * FROM users');
    AppLogger.db('Query returned 15 results');
    AppLogger.db('Closing database connection');

    // Database errors
    AppLogger.db('❌ Database constraint violation');
    AppLogger.db('🔄 Rolling back transaction');
  }

  void paymentFlow() {
    // Payment processing
    AppLogger.payment('Initiating payment for course: Advanced Flutter');
    AppLogger.payment(r'Amount: $49.99, Currency: USD');
    AppLogger.payment('Payment method: Credit Card (**** 1234)');
    AppLogger.payment('✅ Payment successful - Transaction ID: TXN123456');

    // Payment errors
    AppLogger.payment('❌ Payment failed - Insufficient funds');
    AppLogger.payment('🔄 Redirecting to payment retry screen');
  }
}
