import 'package:betaversion/core/ui/bottom_sheet/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationBottomSheet extends StatelessWidget {
  const NotificationBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      title: 'Notifications',
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      child: const NotificationBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.separated(
      shrinkWrap: true,
      itemCount: 2,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return _NotificationItem(
          icon: index == 0 ? Iconsax.message : Iconsax.tick_circle,
          title: index == 0 ? 'New message received' : 'Task completed',
          subtitle: index == 0
              ? 'You have a new message from the team'
              : 'Your project has been successfully updated',
          time: index == 0 ? '2 min ago' : '1 hour ago',
          isUnread: index == 0,
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final bool isUnread;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isUnread
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          icon,
          color: isUnread
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
        ),
      ),
      trailing: Text(
        time,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.textTheme.labelSmall?.color?.withOpacity(0.6),
        ),
      ),
    );
  }
}
