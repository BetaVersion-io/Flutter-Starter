import 'package:betaversion/theme/providers/theme_provider.dart';
import 'package:betaversion/theme/widgets/theme_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class ThemeCard extends HookConsumerWidget {
  const ThemeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Card(
      elevation: 1,
      child: ListTile(
        leading: const Icon(Iconsax.paintbucket, size: 24),
        title: const Text(
          'Theme',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          _getThemeDescription(themeMode),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          Iconsax.arrow_right_3,
          color: Theme.of(context).textTheme.bodySmall?.color,
          size: 20,
        ),
        onTap: () => _showThemeBottomSheet(context, ref),
      ),
    );
  }

  String _getThemeDescription(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light mode';
      case ThemeMode.dark:
        return 'Dark mode';
      case ThemeMode.system:
        return 'System default';
    }
  }

  void _showThemeBottomSheet(BuildContext context, WidgetRef ref) {
    ThemeBottomSheet.show(context: context);
  }
}
