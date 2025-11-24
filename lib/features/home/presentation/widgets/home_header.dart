import 'package:betaversion/core/ui/avatar/profile_avatar.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:betaversion/theme/extensions/extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String? userAvatar;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    this.userAvatar,
    this.notificationCount = 0,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(onTap: () => context.pushNamed(RouteConstants.profile)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withAlpha(150),
                ),
              ),
              Text(
                userName,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Badge(
          isLabelVisible: notificationCount > 0,
          offset: const Offset(-5, 4),
          label: Text('$notificationCount'),
          child: AppIconButton(
            icon: Iconsax.notification,
            onPressed: onNotificationTap,
          ),
        ),
      ],
    );
  }
}
