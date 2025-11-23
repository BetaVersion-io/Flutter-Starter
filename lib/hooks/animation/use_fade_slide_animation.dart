import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FadeSlideAnimationData {
  const FadeSlideAnimationData({
    required this.controller,
    required this.fadeAnimation,
    required this.slideAnimation,
  });
  final AnimationController controller;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
}

/// A custom hook that provides fade and slide animations with configurable parameters.
///
/// Parameters:
/// - [duration]: Duration of the animation (default: 500ms)
/// - [slideBeginOffset]: Starting offset for slide animation (default: Offset(0, 0.08))
/// - [fadeInCurve]: Curve for fade animation (default: Curves.easeInOut)
/// - [slideCurve]: Curve for slide animation (default: Curves.easeOutCubic)
///
/// Returns a [FadeSlideAnimationData] object containing:
/// - controller: The animation controller
/// - fadeAnimation: The fade animation
/// - slideAnimation: The slide animation
FadeSlideAnimationData useFadeSlideAnimation({
  Duration duration = const Duration(milliseconds: 1000),
  Offset slideBeginOffset = const Offset(0, 0.08),
  Curve fadeInCurve = Curves.easeInOut,
  Curve slideCurve = Curves.easeOutCubic,
}) {
  final animationController = useAnimationController(duration: duration);

  final fadeAnimation = useMemoized(
    () => CurvedAnimation(parent: animationController, curve: fadeInCurve),
    [animationController],
  );

  final slideAnimation = useMemoized(
    () => Tween<Offset>(
      begin: slideBeginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animationController, curve: slideCurve)),
    [animationController],
  );

  return FadeSlideAnimationData(
    controller: animationController,
    fadeAnimation: fadeAnimation,
    slideAnimation: slideAnimation,
  );
}
