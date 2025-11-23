import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/core/ui/icons/app_icon.dart';
import 'package:betaversion/core/ui/shimmer/common_shimmer.dart';
import 'package:betaversion/theme/constants/sizes.dart';

class CommonListCard extends StatelessWidget {
  const CommonListCard({
    required this.title,
    super.key,
    this.imageUrl,
    this.titleStyle,
    this.content,
    this.actionElement,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.imageSize = 60,
    this.backgroundColor,
    this.hasImage = false,
    this.imageAlignment = Alignment.center,
  });
  final String? imageUrl;
  final String title;
  final TextStyle? titleStyle;
  final Widget? content;
  final Widget? actionElement;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final double? borderRadius;
  final double imageSize;
  final Color? backgroundColor;
  final bool hasImage;
  final Alignment imageAlignment;

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.borderRadiusLg,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSizes.defaultSpace / 2),
          child: Row(
            children: [
              // Image Widget
              if (hasImage || imageUrl != null) ...[
                CardImageWidget(
                  imageUrl: imageUrl,
                  imageSize: imageSize,
                  borderRadius: borderRadius ?? AppSizes.borderRadiusLg,
                  alignment: imageAlignment,
                ),
                const Gap(12),
              ],

              // Content Widget
              Expanded(
                child: _CardContentWidget(
                  title: title,
                  titleStyle: titleStyle,
                  content: content,
                ),
              ),

              // Optional trailing element
              if (actionElement != null) actionElement!,
            ],
          ),
        ),
      ),
    );
  }
}

// Separate widget for image handling
class CardImageWidget extends StatelessWidget {
  const CardImageWidget({
    required this.imageUrl,
    required this.imageSize,
    required this.borderRadius,
    super.key,
    this.alignment = Alignment.center,
  });
  final String? imageUrl;
  final double imageSize;
  final double borderRadius;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? _NetworkImageWidget(
              imageUrl: imageUrl!,
              imageSize: imageSize,
              borderRadius: borderRadius,
              alignment: alignment,
            )
          : _DefaultImageWidget(
              imageSize: imageSize,
              borderRadius: borderRadius,
            ),
    );
  }
}

// Network image with loading and error states
class _NetworkImageWidget extends StatelessWidget {
  const _NetworkImageWidget({
    required this.imageUrl,
    required this.imageSize,
    required this.borderRadius,
    this.alignment = Alignment.center,
  });
  final String imageUrl;
  final double imageSize;
  final double borderRadius;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: imageSize,
      width: imageSize,
      fit: BoxFit.cover,
      alignment: alignment,
      placeholder: (context, url) => _ImagePlaceholderWidget(
        imageSize: imageSize,
        borderRadius: borderRadius,
      ),
      errorWidget: (context, url, error) =>
          _DefaultImageWidget(imageSize: imageSize, borderRadius: borderRadius),
    );
  }
}

// Shimmer placeholder during loading
class _ImagePlaceholderWidget extends StatelessWidget {
  const _ImagePlaceholderWidget({
    required this.imageSize,
    required this.borderRadius,
  });
  final double imageSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return CommonShimmerShapes.rectangle(
      height: imageSize,
      width: imageSize,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}

// Default logo widget for error or missing image
class _DefaultImageWidget extends StatelessWidget {
  const _DefaultImageWidget({
    required this.imageSize,
    required this.borderRadius,
  });
  final double imageSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: imageSize,
      width: imageSize,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const Padding(padding: EdgeInsets.all(8), child: AppIcon()),
    );
  }
}

// Content widget for title and additional content
class _CardContentWidget extends StatelessWidget {
  const _CardContentWidget({
    required this.title,
    this.titleStyle,
    this.content,
  });
  final String title;
  final TextStyle? titleStyle;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              titleStyle ??
              Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
        ),
        if (content != null) content!,
      ],
    );
  }
}

// Extension for common usage patterns
extension CommonListCardExtensions on CommonListCard {
  /// Create a card with image support
  static CommonListCard withImage({
    required String title,
    String? imageUrl,
    Widget? content,
    Widget? actionElement,
    VoidCallback? onTap,
    double imageSize = 60,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return CommonListCard(
      title: title,
      imageUrl: imageUrl,
      content: content,
      actionElement: actionElement,
      onTap: onTap,
      imageSize: imageSize,
      padding: padding,
      margin: margin,
      hasImage: true,
    );
  }

  /// Create a card without image
  static CommonListCard withoutImage({
    required String title,
    Widget? content,
    Widget? actionElement,
    VoidCallback? onTap,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return CommonListCard(
      title: title,
      content: content,
      actionElement: actionElement,
      onTap: onTap,
      padding: padding,
      margin: margin,
    );
  }
}

// Usage examples:
/*
// With image URL
CommonListCardExtensions.withImage(
  title: "Subject Name",
  imageUrl: "https://example.com/image.jpg",
  content: Text("Additional content"),
)

// Without image URL but shows default logo
CommonListCardExtensions.withImage(
  title: "Subject Name", 
  imageUrl: null, // Will show default logo
  content: Text("Additional content"),
)

// No image at all
CommonListCardExtensions.withoutImage(
  title: "Subject Name",
  content: Text("Additional content"),
)

// Direct usage
CommonListCard(
  title: "Subject Name",
  hasImage: true, // Will show default logo if imageUrl is null
  imageUrl: null,
  content: Text("Additional content"),
)
*/
