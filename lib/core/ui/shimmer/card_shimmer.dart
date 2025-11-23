import 'package:betaversion/core/ui/shimmer/common_shimmer.dart';
import 'package:betaversion/theme/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardShimmer extends StatelessWidget {
  final bool hasImage;
  final bool hasContent;
  final bool hasActionElement;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final double? borderRadius;
  final double imageSize;
  final Color? backgroundColor;

  const CardShimmer({
    super.key,
    this.hasImage = true,
    this.hasContent = true,
    this.hasActionElement = false,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.imageSize = 60,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: elevation ?? 1,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.borderRadiusLg,
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppSizes.defaultSpace / 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Optional Image Shimmer
            if (hasImage) ...[
              CommonShimmerShapes.rectangle(
                height: imageSize,
                width: imageSize,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              ),
              const Gap(12),
            ],

            // Title & Content Shimmer
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Shimmer
                  CommonShimmerShapes.line(width: double.infinity, height: 18),

                  if (hasContent) ...[
                    const Gap(8),
                    // Content Shimmer - Multiple lines
                    CommonShimmerShapes.line(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 14,
                    ),
                  ],
                ],
              ),
            ),

            // Optional Action Element Shimmer
            if (hasActionElement)
              CommonShimmerShapes.rectangle(
                height: 24,
                width: 24,
                borderRadius: BorderRadius.circular(4),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper widget to create multiple shimmer cards
class CardShimmerList extends StatelessWidget {
  final int itemCount;
  final bool hasImage;
  final bool hasContent;
  final bool hasActionElement;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final double? borderRadius;
  final double imageSize;
  final Color? backgroundColor;

  const CardShimmerList({
    super.key,
    this.itemCount = 5,
    this.hasImage = true,
    this.hasContent = true,
    this.hasActionElement = false,
    this.padding,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.elevation,
    this.borderRadius,
    this.imageSize = 60,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return CardShimmer(
          hasImage: hasImage,
          hasContent: hasContent,
          hasActionElement: hasActionElement,
          padding: padding,
          margin: margin,
          elevation: elevation,
          borderRadius: borderRadius,
          imageSize: imageSize,
          backgroundColor: backgroundColor,
        );
      },
    );
  }
}
