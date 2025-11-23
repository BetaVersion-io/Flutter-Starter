import 'package:flutter/material.dart';

/// A reusable container widget with customizable gradient background.
///
/// This widget provides a container with a linear gradient that can be
/// customized with different colors, alignment, and child widgets.
class GradientContainer extends StatelessWidget {
  /// The child widget to be placed inside the gradient container
  final Widget child;

  /// List of colors for the gradient. Defaults to light blue to white gradient.
  final List<Color> colors;

  /// The starting point of the gradient. Defaults to topCenter.
  final AlignmentGeometry begin;

  /// The ending point of the gradient. Defaults to bottomCenter.
  final AlignmentGeometry end;

  /// Optional width of the container. Defaults to double.infinity.
  final double? width;

  /// Optional height of the container. Defaults to double.infinity.
  final double? height;

  /// Optional padding for the child widget
  final EdgeInsetsGeometry? padding;

  const GradientContainer({
    super.key,
    required this.child,
    this.colors = const [
      Color(0xFF78CAFF), // Light blue
      Color(0xFFFFFFFF), // White
    ],
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding,
  });

  /// Factory constructor for light blue to white gradient (most common pattern)
  factory GradientContainer.lightBlueToWhite({
    Key? key,
    required Widget child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return GradientContainer(
      key: key,
      width: width,
      height: height,
      padding: padding,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: begin, end: end, colors: colors),
      ),
      child: child,
    );
  }
}
