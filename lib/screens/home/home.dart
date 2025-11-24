import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/features/home/presentation/home_header.dart';
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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: HomeHeader(),
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
