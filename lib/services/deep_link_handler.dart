/// Deep Link Handler
///
/// Determines whether a URL should be handled inside the app or launched
/// externally and performs the appropriate navigation or launch.
library;

import 'package:betaversion/services/navigation_service.dart';
import 'package:betaversion/utils/device/device_utility.dart';
import 'package:betaversion/utils/logger/logger.dart';

/// Opens a URL either inside the app (if it's a recognized deep link) or
/// forwards it to the system to be handled by an external application.
Future<void> openDeepLink(String url) async {
  if (url.trim().isEmpty) {
    return;
  }

  try {
    final trimmed = url.trim();
    final uri = Uri.parse(trimmed);

    if (_isInternalDeepLink(uri)) {
      final route = _buildInternalRoute(uri);
      AppLogger.navigation('🔗 Navigating to internal deep link', route);
      NavigationService.go(route);
      return;
    }

    // If there's no scheme but it looks like a domain, default to https
    if (uri.scheme.isEmpty && _looksLikeDomainPath(trimmed)) {
      final httpsUrl = 'https://$trimmed';
      AppLogger.navigation('🌐 Normalizing URL to HTTPS', httpsUrl);
      await DeviceUtils.launchUrl(httpsUrl);
      return;
    }

    AppLogger.navigation('🌐 Opening external URL', trimmed);
    await DeviceUtils.launchUrl(uri.toString());
  } on FormatException catch (error, stackTrace) {
    AppLogger.e('Invalid URL passed to openDeepLink', error, stackTrace);
  } catch (error, stackTrace) {
    AppLogger.e('Failed to open deep link', error, stackTrace);
  }
}

const _allowedHosts = {
  'betaversion.in',
  'www.betaversion.in',
  'app.betaversion.in',
  'link.betaversion.in',
};

bool _isInternalDeepLink(Uri uri) {
  final scheme = uri.scheme.toLowerCase();

  if (scheme == 'betaversion') {
    return true;
  }

  if (scheme == 'https' || scheme == 'http') {
    final host = uri.host.toLowerCase();
    if (_allowedHosts.contains(host)) {
      if (uri.pathSegments.isEmpty) {
        return false;
      }
      return uri.pathSegments.first == 'app';
    }
  }

  if (scheme.isEmpty) {
    if (uri.pathSegments.isEmpty) return false;

    // Handle bare domain paths like "betaversion.in/app/..."
    final first = uri.pathSegments.first.toLowerCase();
    if (_allowedHosts.contains(first)) {
      if (uri.pathSegments.length < 2) return false;
      return uri.pathSegments[1] == 'app';
    }

    // Handle bare app paths like "app/..."
    return first == 'app';
  }

  return false;
}

String _buildInternalRoute(Uri uri) {
  final segments = <String>[];

  if (uri.scheme == 'betaversion') {
    if (uri.host.isNotEmpty) {
      segments.add(uri.host);
    }
  }

  var pathSegs = uri.pathSegments.where((s) => s.isNotEmpty).toList();

  // If URL came as a bare domain path like "betaversion.in/app/...",
  // drop the domain segment so we get "/app/..." as the route.
  if (pathSegs.isNotEmpty &&
      _allowedHosts.contains(pathSegs.first.toLowerCase())) {
    pathSegs = pathSegs.sublist(1);
  }

  segments.addAll(pathSegs);

  final basePath = segments.isEmpty ? '/' : '/${segments.join('/')}';
  final buffer = StringBuffer(basePath);

  if (uri.query.isNotEmpty) {
    buffer
      ..write('?')
      ..write(uri.query);
  }

  if (uri.fragment.isNotEmpty) {
    buffer
      ..write('#')
      ..write(uri.fragment);
  }

  return buffer.toString();
}

bool _looksLikeDomainPath(String value) {
  // Heuristic: contains a dot in the first segment and doesn't start with '/'
  // e.g., "betaversion.in/..." or "www.betaversion.in" -> true
  if (value.startsWith('/')) return false;
  final first = value.split('/').first.toLowerCase();
  return first.contains('.');
}
