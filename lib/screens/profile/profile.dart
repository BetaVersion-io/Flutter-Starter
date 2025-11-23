import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/core/ui/avatar/profile_avatar.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:betaversion/theme/widgets/theme_bottom_sheet.dart';
import 'package:betaversion/theme/widgets/theme_color_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;

    return AppScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  const ProfileAvatar(size: 100),
                  const SizedBox(height: 16),
                  Text(
                    'Satyam',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'satyam@betaversion.io',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Profile options
            _ProfileOptionTile(
              icon: Iconsax.user_edit,
              title: 'Edit Profile',
              onTap: () {},
            ),
            _ProfileOptionTile(
              icon: Iconsax.notification,
              title: 'Notifications',
              onTap: () {},
            ),
            _ProfileOptionTile(
              icon: Iconsax.lock,
              title: 'Privacy',
              onTap: () {},
            ),
            _ProfileOptionTile(
              icon: Iconsax.brush_1,
              title: 'Theme',
              onTap: () => ThemeBottomSheet.show(context: context),
            ),
            _ProfileOptionTile(
              icon: Iconsax.colorfilter,
              title: 'Theme Color',
              onTap: () => ThemeColorBottomSheet.show(context: context),
            ),
            _ProfileOptionTile(
              icon: Iconsax.setting_2,
              title: 'Settings',
              onTap: () {},
            ),
            _ProfileOptionTile(
              icon: Iconsax.info_circle,
              title: 'Help & Support',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _ProfileOptionTile(
              icon: Iconsax.logout,
              title: 'Log Out',
              isDestructive: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive ? theme.colorScheme.error : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: theme.paperColor,
        borderRadius: BorderRadius.circular(16),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          leading: Icon(
            icon,
            color: color ?? theme.colorScheme.onSurface,
            size: 20,
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Iconsax.arrow_right_3,
            size: 18,
            color: color ?? theme.textTheme.bodyLarge?.color?.withAlpha(100),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
