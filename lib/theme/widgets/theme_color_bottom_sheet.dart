import 'package:betaversion/core/ui/bottom_sheet/app_bottom_sheet.dart';
import 'package:betaversion/theme/providers/theme_color_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeColorBottomSheet extends HookConsumerWidget {
  const ThemeColorBottomSheet({super.key});

  static void show({required BuildContext context}) {
    AppBottomSheet.show(
      context: context,
      title: 'Choose Color',
      child: const ThemeColorBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor = ref.watch(themeColorProvider);
    final colorNotifier = ref.read(themeColorProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: AppThemeColor.values.map((themeColor) {
            final isSelected = currentColor == themeColor;
            return _ColorOption(
              color: themeColor.color,
              label: themeColor.label,
              isSelected: isSelected,
              onTap: () {
                colorNotifier.setColor(themeColor);
                context.pop();
              },
            );
          }).toList(),
        ),
        Gap(MediaQuery.of(context).padding.bottom + 20),
      ],
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  )
                : null,
          ),
          const Gap(8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
