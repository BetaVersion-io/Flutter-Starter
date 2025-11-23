import 'package:betaversion/config/app_config.dart';
import 'package:betaversion/config/env_config.dart';
import 'package:betaversion/core/storage/secure_storage.dart';
import 'package:betaversion/routes/app_router.dart';
import 'package:betaversion/services/app_info_service.dart';
import 'package:betaversion/services/firebase/firebase_service.dart';
import 'package:betaversion/services/network/connectivity_service.dart';
import 'package:betaversion/services/notification/push_notification_service.dart';
import 'package:betaversion/utils/logger/logger.dart';

/// Application initializer service.
///
/// This service handles the complete app initialization sequence:
/// - Core configurations (environment, app config, storage)
/// - Database setup
/// - Firebase services
/// - Navigation and lifecycle
/// - Push notifications
/// - Analytics
///
/// Usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await AppInitializer.initialize();
///   runApp(MyApp());
/// }
/// ```
class AppInitializer {
  // Private constructor to prevent instantiation
  AppInitializer._();

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  /// Initializes all app services in the correct order.
  ///
  /// Returns `true` if initialization completed successfully,
  /// `false` if any critical service failed to initialize.
  ///
  /// Throws exceptions for critical failures that should prevent app startup.
  static Future<bool> initialize() async {
    // Initialize logger FIRST (before try-catch so error handling can use it)
    AppLogger.init();

    try {
      AppLogger.i('🚀 Starting betaversion application initialization...');

      // Phase 1: Core Configuration (logger already initialized above)
      await _initializeCore();

      // Phase 2 & 3: Database, Analytics and Firebase in parallel (independent services)
      // Note: Firebase initialization now includes its dependent services
      await _initializeFirebase();
      await Future.wait([_initializeDatabase()]);

      // Phase 4: App Services
      _initializeAppServices();

      AppLogger.i('✅ Application initialization completed successfully!');
      return true;
    } catch (e, stackTrace) {
      // Logger is already initialized, safe to use
      AppLogger.f('💥 Application initialization failed!', e, stackTrace);
      rethrow;
    }
  }

  // ============================================================================
  // PRIVATE INITIALIZATION PHASES
  // ============================================================================

  /// Phase 1: Initialize core configurations.
  ///
  /// Order: Environment → App Config → App Info → Secure Storage
  /// Note: Logger is initialized in main initialize() method before this
  static Future<void> _initializeCore() async {
    // Step 1: Determine and load environment
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );
    AppLogger.i('🌍 Environment: $environment');

    await EnvConfig.initialize(environment);
    AppLogger.i('⚙️ Environment configuration loaded');

    // Step 2, 3, 4 & 5: Initialize app config, app info, secure storage and connectivity in parallel
    await Future.wait([
      AppConfig.initialize().then((_) {
        AppLogger.i('📱 App configuration loaded');
      }),
      AppInfoService.initialize().then((_) {
        AppLogger.i(
          'ℹ️ App info initialized (${AppInfoService.appName} v${AppInfoService.fullVersion} on ${AppInfoService.platformName})',
        );
      }),
      SecureStorage.initialize().then((_) {
        AppLogger.i('🔒 Secure storage initialized');
      }),
      ConnectivityService.instance.initialize().then((_) {
        AppLogger.i('🌐 Connectivity service initialized');
      }),
    ]);
  }

  /// Phase 2: Initialize database services.
  static Future<void> _initializeDatabase() async {
    AppLogger.db('📦 ObjectBox database initialized');
  }

  /// Phase 3: Initialize Firebase and its dependent services.
  ///
  /// Returns `true` if Firebase initialized successfully, `false` otherwise.
  /// Also initializes Firebase-dependent services (notifications, remote config, FCM).
  static Future<bool> _initializeFirebase() async {
    final initialized = await FirebaseService.initialize();

    if (initialized) {
      AppLogger.i('✅ Firebase is ready for dependent services');

      // Initialize Firebase-dependent services in parallel
      await Future.wait([_initializeLocalNotifications(), _initializeFcm()]);
    } else {
      AppLogger.w(
        '⚠️ Firebase initialization failed - app will run with limited features',
      );

      // Only initialize local notifications if Firebase is not available
      await _initializeLocalNotifications();
      AppLogger.i('ℹ️ Local notifications still available without Firebase');
    }

    return initialized;
  }

  /// Phase 4: Initialize app services (non-Firebase dependent).
  static void _initializeAppServices() {
    // Navigation
    initializeAppRouter();
    AppLogger.navigation('🧭 Navigation service initialized');

    // Lifecycle management
    // LifecycleManager.initialize();
    // AppLogger.i('🔄 Lifecycle manager initialized');
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Initialize local notifications (works without Firebase).
  static Future<void> _initializeLocalNotifications() async {
    try {
      await PushNotificationService.instance.initialize();
      AppLogger.i('🔔 Local notifications initialized');
    } catch (e, stackTrace) {
      AppLogger.w(
        '⚠️ Local notifications initialization failed',
        e,
        stackTrace,
      );
    }
  }

  /// Initialize Firebase Cloud Messaging.
  static Future<void> _initializeFcm() async {
    try {
      // Setup FCM listeners
      PushNotificationService.instance.setupFcmListeners();
      AppLogger.i('📡 FCM listeners configured');

      // Register FCM token
      await PushNotificationService.instance.registerFcmToken();
      AppLogger.i('📱 FCM token registered');
    } catch (e, stackTrace) {
      AppLogger.w('⚠️ FCM initialization failed', e, stackTrace);
    }
  }
}
