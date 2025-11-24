import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Reusable header widget for authentication screens
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    required this.title,
    required this.subtitle,
    super.key,
    this.icon,
    this.iconSize = 80.0,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize,
            color: theme.colorScheme.primary,
          ),
          const Gap(24),
        ],
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
