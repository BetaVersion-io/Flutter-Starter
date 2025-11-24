import 'package:betaversion/theme/constants/sizes.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final List<StatItem> stats;

  const StatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha(50),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Row(
              children: [
                if (index > 0)
                  Container(
                    width: 1,
                    height: 40,
                    color: theme.colorScheme.outline.withAlpha(50),
                  ),
                Expanded(child: _StatItemWidget(stat: stat)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StatItemWidget extends StatelessWidget {
  final StatItem stat;

  const _StatItemWidget({required this.stat});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      children: [
        Text(
          stat.value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class StatItem {
  final String label;
  final String value;

  const StatItem({
    required this.label,
    required this.value,
  });
}
