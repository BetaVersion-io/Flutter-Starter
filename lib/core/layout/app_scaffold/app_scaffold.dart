import 'package:betaversion/theme/dark_theme.dart';
import 'package:betaversion/theme/theme.dart';
import 'package:flutter/material.dart';

/// Main scaffold widget for the application with support for themes and gradients
class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool showBackArrow;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final bool safeArea;
  final EdgeInsetsGeometry? bodyPadding;
  final List<Widget>? actions;
  final VoidCallback? onBackButtonTap;
  final bool resizeToAvoidBottomInset;
  final bool canPop;
  final void Function(bool, dynamic)? onPopInvokedWithResult;
  final ThemeMode? themeMode;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  final bool useDefaultGradient;

  const AppScaffold({
    required this.body,
    super.key,
    this.title,
    this.showBackArrow = false,
    this.enablePullToRefresh = true,
    this.onRefresh,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.appBar,
    this.safeArea = true,
    this.bodyPadding,
    this.actions,
    this.onBackButtonTap,
    this.resizeToAvoidBottomInset = true,
    this.canPop = true,
    this.onPopInvokedWithResult,
    this.themeMode,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.useDefaultGradient = false,
  });

  /// Factory constructor for creating an AppScaffold with a gradient background.
  ///
  /// This constructor provides a convenient way to create a scaffold with a
  /// gradient background without manually managing a Stack and GradientContainer.
  ///
  /// The gradient is rendered as a background layer, and the scaffold is placed
  /// on top with a transparent background color.
  ///
  /// Example usage:
  /// ```dart
  /// AppScaffold.gradient(
  ///   title: "My Screen",
  ///   body: MyContent(),
  ///   gradientColors: [Colors.blue, Colors.white],
  /// )
  /// ```
  ///
  /// For the default light blue to white gradient:
  /// ```dart
  /// AppScaffold.gradient(
  ///   title: "My Screen",
  ///   body: MyContent(),
  /// )
  /// ```
  factory AppScaffold.gradient({
    required Widget body,
    Key? key,
    String? title,
    bool showBackArrow = false,
    bool enablePullToRefresh = true,
    Future<void> Function()? onRefresh,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    Widget? bottomNavigationBar,
    Widget? drawer,
    Widget? endDrawer,
    PreferredSizeWidget? appBar,
    bool safeArea = true,
    EdgeInsetsGeometry? bodyPadding,
    List<Widget>? actions,
    VoidCallback? onBackButtonTap,
    bool resizeToAvoidBottomInset = true,
    bool canPop = true,
    void Function(bool, dynamic)? onPopInvokedWithResult,
    ThemeMode? themeMode,
    List<Color>? gradientColors,
    AlignmentGeometry? gradientBegin,
    AlignmentGeometry? gradientEnd,
  }) {
    return AppScaffold(
      key: key,
      title: title,
      body: body,
      showBackArrow: showBackArrow,
      enablePullToRefresh: enablePullToRefresh,
      onRefresh: onRefresh,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      safeArea: safeArea,
      bodyPadding: bodyPadding,
      actions: actions,
      onBackButtonTap: onBackButtonTap,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      themeMode: themeMode,
      gradientColors: gradientColors,
      gradientBegin: gradientBegin ?? Alignment.topCenter,
      gradientEnd: gradientEnd ?? Alignment.bottomCenter,
      useDefaultGradient: gradientColors == null,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget = body;

    // Apply padding if specified
    if (bodyPadding != null) {
      bodyWidget = Padding(padding: bodyPadding!, child: bodyWidget);
    }

    // Wrap in SafeArea if enabled
    if (safeArea) {
      bodyWidget = SafeArea(child: bodyWidget);
    }

    // Add pull-to-refresh functionality if enabled
    if (enablePullToRefresh && onRefresh != null) {
      bodyWidget = RefreshIndicator(onRefresh: onRefresh!, child: bodyWidget);
    }

    final scaffold = Scaffold(
      appBar: appBar,
      body: bodyWidget,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    Widget result = scaffold;

    // Wrap with PopScope if canPop is false or onPopInvokedWithResult is provided
    if (!canPop || onPopInvokedWithResult != null) {
      result = PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: result,
      );
    }

    // Apply theme override if specified
    if (themeMode != null) {
      final effectiveTheme = _getThemeData(context, themeMode!);
      result = Theme(data: effectiveTheme, child: result);
    }

    // Wrap with gradient background if gradient colors are specified or useDefaultGradient is true
    final effectiveGradientColors =
        gradientColors ??
        (useDefaultGradient
            ? [
                _getTintedPrimaryColor(context),
                Theme.of(context).scaffoldBackgroundColor,
              ]
            : null);

    if (effectiveGradientColors != null) {
      result = Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: gradientBegin ?? Alignment.topCenter,
                end: gradientEnd ?? Alignment.bottomCenter,
                colors: effectiveGradientColors,
              ),
            ),
          ),
          result,
        ],
      );
    }

    return result;
  }

  /// Creates a tinted primary color based on theme brightness
  /// Dark mode: darkens the primary color (blends with scaffold background)
  /// Light mode: lightens the primary color (blends with white)
  Color _getTintedPrimaryColor(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    if (isDark) {
      // Darken: blend primary with scaffold background
      return Color.lerp(
        theme.scaffoldBackgroundColor,
        primaryColor,
        0.15,
      )!;
    } else {
      // Lighten: blend primary with white
      return Color.lerp(
        Colors.white,
        primaryColor,
        0.1,
      )!;
    }
  }

  /// Determines which theme to use based on the provided theme mode
  ThemeData _getThemeData(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return appTheme;
      case ThemeMode.dark:
        return darkAppTheme;
      case ThemeMode.system:
        final brightness = MediaQuery.of(context).platformBrightness;
        return brightness == Brightness.dark ? darkAppTheme : appTheme;
    }
  }
}
