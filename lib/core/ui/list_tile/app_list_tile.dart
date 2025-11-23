import 'package:flutter/material.dart';

/// A customizable list tile widget used across the app for consistent UI
///
/// This widget provides a configurable list item with optional leading icon,
/// title, subtitle, trailing widget, and tap handling.
class AppListTile extends StatelessWidget {
  /// The primary text to display
  final String title;

  /// The secondary text to display below the title
  final String? subtitle;

  /// The icon to display before the title
  final IconData? leadingIcon;

  /// Custom widget to display before the title (overrides leadingIcon)
  final Widget? leading;

  /// Custom widget to display after the title
  final Widget? trailing;

  /// Callback when the list tile is tapped
  final VoidCallback? onTap;

  /// Padding around the list tile content
  final EdgeInsetsGeometry? contentPadding;

  /// The color of the leading icon
  final Color? iconColor;

  /// The size of the leading icon
  final double? iconSize;

  /// The style for the title text
  final TextStyle? titleStyle;

  /// The style for the subtitle text
  final TextStyle? subtitleStyle;

  /// Whether to show a divider below the tile
  final bool showDivider;

  /// The color of the divider
  final Color? dividerColor;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leadingIcon,
    this.leading,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.iconColor,
    this.iconSize,
    this.titleStyle,
    this.subtitleStyle,
    this.showDivider = false,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
            contentPadding: contentPadding ?? EdgeInsets.zero,
            leading:
                leading ??
                (leadingIcon != null
                    ? Icon(leadingIcon, color: iconColor, size: iconSize)
                    : null),
            title: Text(title, style: titleStyle ?? theme.textTheme.bodyLarge),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: subtitleStyle ?? theme.textTheme.bodyMedium,
                  )
                : null,
            trailing: trailing,
          ),
        ),
        if (showDivider) Divider(height: 1, color: dividerColor),
      ],
    );
  }
}

/// A list tile specifically designed for settings items
///
/// This is a specialized version of [AppListTile] with defaults
/// optimized for settings screens.
class AppSettingListTile extends StatelessWidget {
  /// The primary text to display
  final String title;

  /// The secondary text to display below the title
  final String? subtitle;

  /// The icon to display before the title
  final IconData? icon;

  /// Callback when the setting is tapped
  final VoidCallback? onTap;

  /// Custom trailing widget (e.g., Switch, Checkbox)
  final Widget? trailing;

  const AppSettingListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      title: title,
      subtitle: subtitle,
      leadingIcon: icon,
      onTap: onTap,
      trailing: trailing,
      contentPadding: EdgeInsets.zero,
    );
  }
}
