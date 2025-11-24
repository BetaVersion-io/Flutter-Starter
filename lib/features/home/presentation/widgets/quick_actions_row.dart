import 'package:betaversion/features/home/domain/entities/quick_action.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:flutter/material.dart';

class QuickActionsRow extends StatelessWidget {
  final List<QuickAction> actions;
  final Function(QuickAction)? onActionTap;

  const QuickActionsRow({
    super.key,
    required this.actions,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions
          .map((action) => _QuickActionItem(
                action: action,
                onTap: () => onActionTap?.call(action),
              ))
          .toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final QuickAction action;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: action.color.withAlpha(26),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              action.icon,
              color: action.color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
