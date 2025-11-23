/// betaversion Application Entry Point
///
/// This is the main entry point for the betaversion educational application.
/// All initialization logic has been moved to dedicated services for
/// better maintainability and cleaner code organization.
///
/// See:
/// - [AppInitializer] for initialization logic
/// - [AppErrorHandler] for error handling
library;

import 'package:betaversion/app.dart';
import 'package:betaversion/core/initialization/app_error_handler.dart';
import 'package:betaversion/core/initialization/app_initializer.dart';
import 'package:betaversion/services/network/query_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fquery/fquery.dart';

/// Application entry point.
///
/// Initializes all required services and starts the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize all app services (non-user specific)
    await AppInitializer.initialize();

    // Start the app with developer mode guard and splash wrapper
    // DeveloperModeGuard blocks the app if developer mode is detected
    // Only enabled in release mode (disabled in debug for development)
    // SplashWrapper handles user-specific initialization and shows splash
    runApp(
      QueryClientProvider(
        queryClient: queryClient,
        child: const ProviderScope(child: App()),
      ),
    );
  } catch (error, stackTrace) {
    // Handle initialization errors gracefully
    AppErrorHandler.handleInitializationError(error, stackTrace);
  }
}
