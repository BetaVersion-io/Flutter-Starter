import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/features/home/data/dummy_data.dart';
import 'package:betaversion/features/home/presentation/widgets/widgets.dart';
import 'package:betaversion/features/notification/presentation/notification_bottom_sheet.dart';
import 'package:betaversion/routes/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold.gradient(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: HomeHeader(
                userName: HomeDummyData.userName,
                userAvatar: HomeDummyData.userAvatar,
                notificationCount: HomeDummyData.unreadNotifications,
                onNotificationTap: () => NotificationBottomSheet.show(context),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Gap(24)),

          // Navigation Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    text: 'Go to Login',
                    onPressed: () => context.pushNamed(RouteConstants.login),
                    expanded: true,
                  ),
                  const Gap(16),
                  AppButton(
                    text: 'Go to Register',
                    onPressed: () => context.pushNamed(RouteConstants.register),
                    variant: AppButtonVariant.outlined,
                    expanded: true,
                  ),
                ],
              ),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
