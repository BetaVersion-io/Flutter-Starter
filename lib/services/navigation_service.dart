/// Navigation Service
///
/// This service provides a way to navigate from anywhere in the app,
/// including from interceptors, services, and other non-widget contexts
/// where direct access to BuildContext is not available.
///
/// Key features:
/// - Global navigation without BuildContext
/// - Navigation from interceptors and services
/// - Go Router integration
/// - Support for both named routes and paths
///
/// Example usage:
/// ```dart
/// // From interceptors or services
/// NavigationService.navigateToLogin();
///
/// // From anywhere with path
/// NavigationService.go('/login');
///
/// // With replacement (no back navigation)
/// NavigationService.goAndReplace('/login');
/// ```
library;

import 'package:go_router/go_router.dart';

/// Global navigation service for app-wide navigation operations
class NavigationService {
  static GoRouter? _router;

  /// Initialize the navigation service with the app's router
  ///
  /// This should be called once during app initialization
  /// [router] - The GoRouter instance used by the app
  static void initialize(GoRouter router) {
    _router = router;
  }

  /// Navigate to a specific path
  ///
  /// [path] - The route path to navigate to
  static void go(String path) {
    _router?.go(path);
  }

  /// Navigate to a specific path and replace current route
  ///
  /// [path] - The route path to navigate to
  static void goAndReplace(String path) {
    _router?.pushReplacement(path);
  }

  /// Navigate to a named route
  ///
  /// [name] - The route name to navigate to
  /// [pathParameters] - Optional path parameters
  /// [queryParameters] - Optional query parameters
  /// [extra] - Optional extra data to pass to the route
  static void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router?.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  static void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router?.pushNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Navigate to a named route and replace the current route
  ///
  /// [name] - The route name to navigate to
  /// [pathParameters] - Optional path parameters
  /// [queryParameters] - Optional query parameters
  /// [extra] - Optional extra data to pass to the route
  static void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
    Object? extra,
  }) {
    _router?.pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Push a new route onto the navigation stack
  ///
  /// [path] - The route path to push
  static void push(String path) {
    _router?.push(path);
  }

  /// Pop the current route from the navigation stack
  static void pop() {
    _router?.pop();
  }

  /// Check if we can pop (if there's a route to go back to)
  static bool canPop() {
    return _router?.canPop() ?? false;
  }
}
