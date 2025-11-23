import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:betaversion/theme/constants/app_assets.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/sizes.dart';
import 'package:betaversion/theme/constants/typography.dart';

/// Pro badge widget with crown icon and gradient background
///
/// Displays a "Pro" badge with a golden gradient background and crown icon
class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.height, this.iconSize, this.textStyle});
  final double? height;
  final double? iconSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 32,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.gold600,
            AppColors.gold300,
            AppColors.gold500,
            AppColors.gold700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSizes.xs,
        children: [
          SvgPicture.asset(
            AppAssets.crownIcon,
            height: iconSize ?? 16,
            width: iconSize ?? 16,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          Text(
            'Pro',
            style:
                textStyle ??
                AppTypography.bodyMediumMedium.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
