import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/core/input/autocomplete_types.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';

class AutocompleteSearchList<T extends AutocompleteOption>
    extends StatelessWidget {
  const AutocompleteSearchList({
    required this.filteredOptions,
    required this.groupedOptions,
    required this.groupConfig,
    required this.expandedGroups,
    required this.isLoading,
    required this.noOptionsText,
    required this.loadingText,
    required this.scrollController,
    required this.multiple,
    required this.isSelected,
    required this.onTapOption,
    required this.optionBuilder,
    super.key,
  });

  final List<T> filteredOptions;
  final Map<String?, List<T>> Function(List<T>) groupedOptions;
  final GroupConfig? groupConfig;
  final ValueNotifier<Set<String>> expandedGroups;
  final bool isLoading;
  final String noOptionsText;
  final String loadingText;
  final ScrollController scrollController;
  final bool multiple;
  final bool Function(T) isSelected;
  final void Function(T) onTapOption;
  final Widget Function(T, bool) optionBuilder;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const Gap(12),
          Text(loadingText),
        ],
      ).center().padding(all: 20);
    }

    if (filteredOptions.isEmpty) {
      return Text(
        noOptionsText,
        style: TextStyle(color: Theme.of(context).hintColor),
      ).center().padding(all: 20);
    }

    final grouped = groupedOptions(filteredOptions);
    final totalCount = grouped.entries
        .map((e) => (e.key != null ? 1 : 0) + e.value.length)
        .fold<int>(0, (a, b) => a + b);

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        int currentIndex = 0;
        for (final entry in grouped.entries) {
          final groupName = entry.key;
          final groupOptions = entry.value;

          // Group header
          if (groupName != null) {
            if (currentIndex == index) {
              final isExpanded = expandedGroups.value.contains(groupName);
              return InkWell(
                onTap: groupConfig?.collapsible ?? false
                    ? () {
                        final newExpanded = Set<String>.from(
                          expandedGroups.value,
                        );
                        if (isExpanded) {
                          newExpanded.remove(groupName);
                        } else {
                          newExpanded.add(groupName);
                        }
                        expandedGroups.value = newExpanded;
                      }
                    : null,
                child:
                    groupConfig?.groupHeaderBuilder?.call(groupName) ??
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      color: Theme.of(context).dividerColor.withAlpha(26),
                      child: Row(
                        children: [
                          Text(
                            groupName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ).expanded(),
                          if (groupConfig?.collapsible ?? false)
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
              );
            }
            currentIndex++;
            if ((groupConfig?.collapsible ?? false) &&
                !expandedGroups.value.contains(groupName)) {
              currentIndex += groupOptions.length;
              continue;
            }
          }

          // Group options
          for (final option in groupOptions) {
            if (currentIndex == index) {
              final selected = isSelected(option);
              return InkWell(
                onTap: () => onTapOption(option),
                child: optionBuilder(option, selected),
              );
            }
            currentIndex++;
          }
        }
        return const SizedBox.shrink();
      },
    );
  }
}
