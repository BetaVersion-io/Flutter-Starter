import 'package:betaversion/core/ui/bottom_sheet/app_bottom_sheet.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:betaversion/theme/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';

// Bottom Sheet Widget
class ThemeBottomSheet extends HookConsumerWidget {
  const ThemeBottomSheet({super.key});

  static void show({required BuildContext context}) {
    AppBottomSheet.show(
      context: context,
      title: 'Choose Theme',
      child: const ThemeBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Theme options
        _buildThemeOption(
          context,
          ref,
          icon: Iconsax.sun_1,
          title: 'Light',
          themeOption: ThemeMode.light,
          isSelected: themeMode == ThemeMode.light,
          onTap: () {
            themeNotifier.setTheme(ThemeMode.light);
            context.pop();
          },
        ),

        _buildThemeOption(
          context,
          ref,
          icon: Iconsax.moon,
          title: 'Dark',
          themeOption: ThemeMode.dark,
          isSelected: themeMode == ThemeMode.dark,
          onTap: () {
            themeNotifier.setTheme(ThemeMode.dark);
            context.pop();
          },
        ),

        _buildThemeOption(
          context,
          ref,
          icon: Iconsax.mobile,
          title: 'System',
          themeOption: ThemeMode.system,
          isSelected: themeMode == ThemeMode.system,
          onTap: () {
            themeNotifier.setTheme(ThemeMode.system);
            context.pop();
          },
        ),

        // Add bottom padding for safe area
        Gap(MediaQuery.of(context).padding.bottom + 20),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required ThemeMode themeOption,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(icon, size: 24).padding(all: 8),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ).expanded(),
          Radio<ThemeMode>(
            value: themeOption,
            groupValue: isSelected ? themeOption : null,
            onChanged: (value) => onTap(),
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
