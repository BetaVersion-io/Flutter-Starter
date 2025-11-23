import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:betaversion/core/ui/badges/pro_badge.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/image_strings.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';

class ActionIcon {
  static Widget arrow(BuildContext context, {Color? color, double size = 22}) {
    return Icon(
      Iconsax.arrow_right_3,
      size: size,
      color: color ?? Theme.of(context).primaryColor,
    );
  }

  static Widget forbidden(
    BuildContext context, {
    Color? color,
    double size = 24,
  }) {
    return Icon(
      Iconsax.forbidden,
      size: size,
      color: color ?? Theme.of(context).primaryColor,
    );
  }

  static Widget pause(BuildContext context, {Color? color, double size = 24}) {
    return SvgPicture.asset(AppImages.pauseIcon, width: size, height: size);
  }

  static Widget check(BuildContext context, {Color? color, double size = 24}) {
    return Transform.translate(
      offset: const Offset(-13, 0), // shift left by 2 pixels
      child: Icon(
        Iconsax.tick_square5,
        size: size,
        color: color ?? AppColors.success600,
      ),
    );
  }

  static Widget onGoing(
    BuildContext context, {
    Color? color,
    double size = 24,
  }) {
    return Icon(
      Iconsax.status,
      size: size,
      color: color ?? AppColors.warning600,
    ).padding(right: 10);
  }

  // Additional helper methods for consistency
  static Widget play(BuildContext context) {
    return Icon(Iconsax.play, size: 20, color: Theme.of(context).primaryColor);
  }

  static Widget pro(BuildContext context, {Color? color, double size = 30}) {
    return ProBadge(height: size);
  }

  // static Widget stop(BuildContext context) {
  //   return Icon(Iconsax.stop, size: 20, color: Theme.of(context).primaryColor);
  // }
}
