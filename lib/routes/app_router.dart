import 'package:betaversion/routes/main_router.dart';
import 'package:betaversion/routes/profile_router.dart';
import 'package:betaversion/services/navigation_service.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/app',
  routes: <RouteBase>[
    // GoRoute(name: RouteConstants.splash, path: '/'),
    mainRouter,
    ...profileRoutes,
  ],
  debugLogDiagnostics: true,
);

/// Initialize the navigation service with the router
/// This should be called during app initialization
void initializeAppRouter() {
  NavigationService.initialize(router);
}
