/// betaversion Application Root Widget
///
/// This library contains the main application widget that serves as the root
/// of the widget tree. It configures the MaterialApp with routing, theming,
/// and system UI overlay styling.
///
/// The App widget sets up:
/// - Navigation routing using GoRouter
/// - Light and dark theme support with system preference detection
/// - System UI overlay styling for status bar and navigation bar
/// - Global app configuration like title and debug settings
///
/// The widget automatically adapts the system UI overlay style based on
/// the current theme brightness to ensure proper contrast and visibility.
library;

import 'package:betaversion/routes/app_router.dart';
import 'package:betaversion/services/deep_link_service.dart';
import 'package:betaversion/services/network/connectivity_toast_listener.dart';
import 'package:betaversion/theme/providers/theme_color_provider.dart';
import 'package:betaversion/theme/providers/theme_provider.dart';
import 'package:betaversion/theme/theme_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// The root widget of the betaversion application.
///
/// This widget serves as the main application container and configures
/// the MaterialApp with all necessary settings including routing, theming,
/// and system UI overlay styling.
///
/// Features:
/// - Automatic theme switching based on system preferences
/// - Custom routing configuration using GoRouter
/// - Dynamic system UI overlay styling based on theme brightness
/// - Proper status bar and navigation bar styling
///
/// The widget extends [HookWidget] to enable the use of Flutter hooks
/// for state management and lifecycle handling.
class App extends HookConsumerWidget {
  /// Creates the root application widget.
  ///
  /// The [key] parameter is used for widget identification and testing purposes.
  const App({super.key});

  /// Builds the root widget tree for the application.
  ///
  /// This method creates and returns a [MaterialApp.router] configured with
  /// the app's routing, theming, and system UI settings. The builder function
  /// wraps the entire app in an [AnnotatedRegion] to control system UI overlay
  /// styling based on the current theme brightness.
  ///
  /// The method automatically detects the current theme brightness and applies
  /// appropriate system UI overlay styles for optimal visual contrast.
  ///
  /// [context] - The build context for this widget
  ///
  /// Returns a fully configured [MaterialApp.router] widget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final currentThemeColor = ref.watch(themeColorProvider);

    // Set up deep link listener for when app is already running
    useEffect(() {
      DeepLinkService.instance.setDeepLinkCallback(router.go);

      return () => DeepLinkService.instance.setDeepLinkCallback(null);
    }, []);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: currentThemeMode,
      title: 'betaversion',
      theme: generateLightTheme(currentThemeColor),
      darkTheme: generateDarkTheme(currentThemeColor),
      builder: (context, child) {
        final brightness = Theme.of(context).brightness;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _systemUiOverlayStyleFromBrightness(brightness),
          child: ConnectivityToastListener(child: child ?? const SizedBox()),
        );
      },
    );
  }

  /// Creates system UI overlay style based on theme brightness.
  ///
  /// This method configures the appearance of system UI elements like the
  /// status bar and navigation bar based on the current theme brightness.
  /// It ensures proper contrast between the app content and system UI elements.
  ///
  /// For dark themes:
  /// - Status bar icons are light colored
  /// - Navigation bar background is black
  /// - Navigation bar icons are light colored
  ///
  /// For light themes:
  /// - Status bar icons are dark colored
  /// - Navigation bar background is white
  /// - Navigation bar icons are dark colored
  ///
  /// The status bar background is always transparent to allow the app
  /// content to extend behind it for an immersive experience.
  ///
  /// [brightness] - The current theme brightness (light or dark)
  ///
  /// Returns a [SystemUiOverlayStyle] configured for the given brightness.
  SystemUiOverlayStyle _systemUiOverlayStyleFromBrightness(
    Brightness brightness,
  ) {
    final isDark = brightness == Brightness.dark;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );
  }
}
