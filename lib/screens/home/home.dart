import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/core/ui/avatar/profile_avatar.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/feature/notification/presentation/notification_bottom_sheet.dart';
import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    return AppScaffold.gradient(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          spacing: 16,
          crossAxisAlignment: .start,
          children: [
            ProfileAvatar(
              size: 48,
              onTap: () => context.pushNamed(RouteConstants.profile),
            ).padding(top: 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'hello,',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                  ),
                ),
                Text(
                  'Satyam',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Badge(
              offset: const Offset(-5, 4),
              label: const Text('2'),
              child: AppIconButton(
                icon: Iconsax.notification,
                onPressed: () => NotificationBottomSheet.show(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
