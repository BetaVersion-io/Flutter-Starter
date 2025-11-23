import 'dart:developer';

import 'package:betaversion/config/env_config.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

/// Application error handler service.
///
/// Provides centralized error handling for application initialization
/// and runtime errors. Shows user-friendly error screens and logs
/// detailed information for debugging.
class AppErrorHandler {
  // Private constructor to prevent instantiation
  AppErrorHandler._();

  /// Handles initialization errors by displaying a fallback UI.
  ///
  /// When the app fails to initialize properly, this creates a minimal
  /// MaterialApp with an error screen instead of crashing.
  ///
  /// Features:
  /// - User-friendly error message
  /// - Detailed error info in dev/staging
  /// - Logs to console for debugging
  ///
  /// [error] - The error that occurred
  /// [stackTrace] - The stack trace associated with the error
  static void handleInitializationError(Object error, StackTrace stackTrace) {
    // Log to console (fallback in case AppLogger isn't initialized)
    log('🚨 App initialization failed: $error');
    log('Stack trace: $stackTrace');

    // Also try AppLogger if available
    try {
      AppLogger.f('💥 Application initialization failed!', error, stackTrace);
    } catch (_) {
      // AppLogger not available, already logged to console
    }

    // Show error UI
    runApp(_buildErrorApp(error, stackTrace));
  }

  /// Builds the error UI app.
  static Widget _buildErrorApp(Object error, StackTrace stackTrace) {
    return MaterialApp(
      title: 'Initialization Error',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon
                  const Icon(
                    Iconsax.info_circle,
                    size: 80,
                    color: AppColors.error500,
                  ),
                  const Gap(32),

                  // Title
                  const Text(
                    'Failed to Initialize App',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(12),

                  // Subtitle
                  const Text(
                    'Something went wrong while starting the app',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(32),

                  // Action message
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Please try:\n'
                      '• Restarting the app\n'
                      '• Checking your internet connection\n'
                      '• Updating to the latest version',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Error details (only in dev/staging)
                  if (_shouldShowErrorDetails()) ...[
                    const Gap(32),
                    _buildErrorDetails(error, stackTrace),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the error details section (dev/staging only).
  static Widget _buildErrorDetails(Object error, StackTrace stackTrace) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error Details (Debug):',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const Gap(8),
          Text(
            error.toString(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.red,
              fontFamily: 'monospace',
            ),
          ),
          const Gap(8),
          const Text(
            'Stack Trace:',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const Gap(4),
          Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: Text(
                stackTrace.toString(),
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black54,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Determines if error details should be shown.
  ///
  /// Shows details in development and staging, hides in production.
  static bool _shouldShowErrorDetails() {
    try {
      return !EnvConfig.isProduction;
    } catch (_) {
      // If EnvConfig isn't initialized, assume dev mode
      return true;
    }
  }
}
