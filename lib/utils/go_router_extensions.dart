/// GoRouter Extensions
///
/// Extensions to make GoRouter navigation easier
library;

import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/services/deep_link_service.dart';
import 'package:betaversion/utils/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension on BuildContext for easier navigation with query params
extension GoRouterExtensions on BuildContext {
  /// Get current query parameters
  Map<String, String> get queryParameters {
    return GoRouterState.of(this).uri.queryParameters;
  }

  /// Get specific query parameter
  String? getQueryParam(String key) {
    return queryParameters[key];
  }

  void goNextRoute([String? name]) {
    final nextRoute = getQueryParam('next');

    DeepLinkService.instance.markAsInitialized();

    AppLogger.i('🔗 [DeepLink] goNextRoute called');
    AppLogger.i('🔗 [DeepLink] next parameter: $nextRoute');
    AppLogger.i('🔗 [DeepLink] fallback route: ${name ?? RouteConstants.home}');

    // If there's a nextRoute and we're going to auth screens, pass it along
    if (nextRoute != null && nextRoute.isNotEmpty) {
      AppLogger.i('🔗 [DeepLink] ✅ Navigating to deep link: $nextRoute');
      go(nextRoute);
      return;
    }

    AppLogger.i(
      '🔗 [DeepLink] ❌ No deep link, going to: ${name ?? RouteConstants.home}',
    );
    goNamed(name ?? RouteConstants.home);
  }

  /// Navigate to named route preserving specific query parameters
  ///
  /// Example:
  /// ```dart
  /// context.goNamedPreserving(
  ///   'login',
  ///   preserve: ['next', 'utm_source'],
  /// );
  /// ```
  void goNamedPreserving(
    String name, {
    Map<String, String>? queryParameters,
    List<String> preserve = const [],
    Object? extra,
  }) {
    final currentParams = this.queryParameters;
    final newParams = <String, String>{};

    // Add preserved params from current route
    for (final key in preserve) {
      if (currentParams.containsKey(key)) {
        newParams[key] = currentParams[key]!;
      }
    }

    // Add new params (overrides preserved if duplicate)
    if (queryParameters != null) {
      newParams.addAll(queryParameters);
    }

    goNamed(
      name,
      queryParameters: newParams.isEmpty ? {} : newParams,
      extra: extra,
    );
  }

  /// Navigate to named route preserving ALL query parameters
  ///
  /// Example:
  /// ```dart
  /// // Current: /landing?next=/video/123&ref=email
  /// context.goNamedPreservingAll('login');
  /// // Result: /login?next=/video/123&ref=email
  /// ```
  void goNamedPreservingAll(
    String name, {
    Map<String, String>? additionalParams,
    Object? extra,
  }) {
    final currentParams = queryParameters;
    final newParams = Map<String, String>.from(currentParams);

    // Add additional params (overrides existing if duplicate)
    if (additionalParams != null) {
      newParams.addAll(additionalParams);
    }

    goNamed(
      name,
      queryParameters: newParams.isEmpty ? {} : newParams,
      extra: extra,
    );
  }

  /// Navigate to path preserving specific query parameters
  void goPreserving(
    String path, {
    Map<String, String>? queryParameters,
    List<String> preserve = const [],
    Object? extra,
  }) {
    final currentParams = this.queryParameters;
    final newParams = <String, String>{};

    // Add preserved params
    for (final key in preserve) {
      if (currentParams.containsKey(key)) {
        newParams[key] = currentParams[key]!;
      }
    }

    // Add new params
    if (queryParameters != null) {
      newParams.addAll(queryParameters);
    }

    // Build URI with query params
    final uri = Uri.parse(path);
    final newUri = uri.replace(queryParameters: newParams);

    go(newUri.toString(), extra: extra);
  }
}

/// Extension on GoRouter for easier state access
extension GoRouterStateExtensions on GoRouterState {
  /// Check if a query parameter exists
  bool hasQueryParam(String key) {
    return uri.queryParameters.containsKey(key);
  }

  /// Get query parameter with default value
  String getQueryParamOr(String key, String defaultValue) {
    return uri.queryParameters[key] ?? defaultValue;
  }

  /// Get all query parameters as a map
  Map<String, String> get allQueryParams {
    return uri.queryParameters;
  }
}
