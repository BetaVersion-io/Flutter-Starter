import 'package:betaversion/theme/constants/image_strings.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    this.size = 32,
    this.fit = BoxFit.contain,
    this.blendMode = BlendMode.srcIn,
    this.color,
  });
  final double? size;
  final BoxFit fit;
  final BlendMode blendMode;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor =
        color ??
        (theme.isDark
            ? theme.colorScheme.onSurface
            : theme.colorScheme.primary);

    return SvgPicture.asset(
      AppImages.appLogo,
      width: size,
      height: size,
      fit: fit,
      colorFilter: ColorFilter.mode(iconColor, blendMode),
    );
  }
}
