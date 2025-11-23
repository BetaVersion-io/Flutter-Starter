import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/theme/constants/sizes.dart';

/// A highly configurable list card widget for consistent UI across the app
///
/// This widget provides extensive customization options:
/// - Optional leading icon/widget
/// - Optional subtitle
/// - Optional trailing widget
/// - Configurable elevation, padding, margin, border radius
/// - Optional border
/// - Theme-aware styling
///
/// Example usage:
/// ```dart
/// AppListCard(
///   title: "Settings",
///   subtitle: "Configure your preferences",
///   leadingIcon: Icons.settings,
///   trailing: Icon(Icons.chevron_right),
///   onTap: () => print("Tapped"),
/// )
/// ```
class AppListCard extends StatelessWidget {
  const AppListCard({
    required this.title,
    super.key,
    this.subtitle,
    this.leadingIcon,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.subtitleStyle,
    this.showIconContainer = false,
    this.iconContainerColor,
    this.iconContainerSize = 40,
    this.leadingSpacing,
    this.titleSubtitleSpacing,
    this.contentPadding,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The primary text to display
  final String title;

  /// The secondary text to display below the title
  final String? subtitle;

  /// The icon to display before the title
  final IconData? leadingIcon;

  /// Custom widget to display before the title (overrides leadingIcon)
  final Widget? leading;

  /// Custom widget to display after the title/subtitle
  final Widget? trailing;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Padding inside the card
  final EdgeInsetsGeometry? padding;

  /// Margin around the card
  final EdgeInsetsGeometry? margin;

  /// Elevation of the card (shadow depth)
  final double? elevation;

  /// Border radius of the card
  final double? borderRadius;

  /// Background color of the card
  final Color? backgroundColor;

  /// Border color (if null, no border is shown)
  final Color? borderColor;

  /// Border width (only used if borderColor is set)
  final double borderWidth;

  /// The color of the leading icon
  final Color? iconColor;

  /// The size of the leading icon
  final double? iconSize;

  /// The style for the title text
  final TextStyle? titleStyle;

  /// The style for the subtitle text
  final TextStyle? subtitleStyle;

  /// Whether to show a container around the leading icon
  final bool showIconContainer;

  /// Background color for the icon container
  final Color? iconContainerColor;

  /// Size of the icon container
  final double iconContainerSize;

  /// Spacing between leading and content
  final double? leadingSpacing;

  /// Spacing between title and subtitle
  final double? titleSubtitleSpacing;

  /// Content padding (controls internal spacing of title/subtitle column)
  final EdgeInsetsGeometry? contentPadding;

  /// Cross axis alignment for the entire row
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: elevation ?? 1,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 6),
      color: backgroundColor ?? theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.borderRadiusLg,
        ),
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: borderWidth)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppSizes.borderRadiusLg,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSizes.defaultSpace / 2),
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              // Leading widget or icon
              if (leading != null || leadingIcon != null) ...[
                _buildLeading(context),
                Gap(leadingSpacing ?? 12),
              ],

              // Content (title and subtitle)
              Expanded(
                child: Padding(
                  padding: contentPadding ?? EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style:
                            titleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      if (subtitle != null) ...[
                        Gap(titleSubtitleSpacing ?? 4),
                        Text(
                          subtitle!,
                          style: subtitleStyle ?? theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Trailing widget
              if (trailing != null) ...[const Gap(8), trailing!],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    if (leading != null) {
      return leading!;
    }

    if (leadingIcon != null) {
      final icon = Icon(leadingIcon, color: iconColor, size: iconSize);

      if (showIconContainer) {
        return Container(
          width: iconContainerSize,
          height: iconContainerSize,
          decoration: BoxDecoration(
            color:
                iconContainerColor ??
                (iconColor ?? Theme.of(context).primaryColor).withAlpha(26),
            borderRadius: BorderRadius.circular(iconContainerSize / 4),
          ),
          child: Center(child: icon),
        );
      }

      return icon;
    }

    return const SizedBox.shrink();
  }
}

/// A specialized variant of AppListCard for settings items
///
/// This provides sensible defaults for settings screens:
/// - Icon with container background
/// - Chevron arrow trailing by default
/// - Consistent spacing
class AppSettingCard extends StatelessWidget {
  const AppSettingCard({
    required this.title,
    required this.icon,
    super.key,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.showChevron = true,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: title,
      subtitle: subtitle,
      leadingIcon: icon,
      iconColor: iconColor ?? Theme.of(context).primaryColor,
      showIconContainer: true,
      onTap: onTap,
      trailing:
          trailing ??
          (showChevron
              ? Icon(Icons.chevron_right, color: Theme.of(context).hintColor)
              : null),
    );
  }
}

/// A specialized variant for simple list items without elevation
///
/// This is useful for items inside bottom sheets or modals where
/// you don't want the card elevation effect.
class AppListItem extends StatelessWidget {
  const AppListItem({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: title,
      subtitle: subtitle,
      leadingIcon: icon,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      elevation: 0,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
    );
  }
}

/// A specialized variant for action items with a colored accent
///
/// This is useful for items that represent actions or quick access
/// features with a colored indicator.
class AppActionCard extends StatelessWidget {
  const AppActionCard({
    required this.title,
    required this.icon,
    required this.accentColor,
    super.key,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      title: title,
      subtitle: subtitle,
      leadingIcon: icon,
      iconColor: accentColor,
      showIconContainer: true,
      iconContainerColor: accentColor.withAlpha(38),
      onTap: onTap,
      trailing: trailing,
    );
  }
}

/// A specialized variant for items with borders instead of elevation
///
/// This creates a flatter, outlined appearance useful for forms or
/// selection interfaces.
class AppBorderedCard extends StatelessWidget {
  const AppBorderedCard({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    this.onTap,
    this.borderColor,
    this.isSelected = false,
  });
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderColor = isSelected
        ? (borderColor ?? theme.primaryColor)
        : theme.dividerColor;

    return AppListCard(
      title: title,
      subtitle: subtitle,
      leadingIcon: icon,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      elevation: 0,
      borderColor: effectiveBorderColor,
      borderWidth: isSelected ? 2 : 1,
    );
  }
}
