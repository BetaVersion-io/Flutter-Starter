import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:betaversion/core/input/autocomplete_search/autocomplete_search_header.dart';
import 'package:betaversion/core/input/autocomplete_search/autocomplete_search_list.dart';
import 'package:betaversion/core/input/autocomplete_search/use_autocomplete_search.dart';
import 'package:betaversion/core/input/autocomplete_types.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';

class AutocompleteSearchContent<T extends AutocompleteOption>
    extends HookWidget {
  const AutocompleteSearchContent({
    super.key,
    this.hintText = 'Type to search...',
    this.textCapitalization = TextCapitalization.none,
    this.multiple = false,
    this.options,
    this.initialOptions,
    this.asyncOptions,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 0,
    this.groupConfig,
    this.optionBuilder,
    this.getOptionLabel,
    this.filterOptions,
    this.noOptionsText = 'No options',
    this.loadingText = 'Loading...',
    this.sortComparator,
    this.initialSelected,
  });

  final String? hintText;
  final TextCapitalization textCapitalization;
  final bool multiple;
  final List<T>? options;
  final List<T>? initialOptions;
  final Future<List<T>> Function(String query, {CancelToken? cancelToken})?
  asyncOptions;
  final Duration debounceDelay;
  final int minSearchLength;
  final GroupConfig? groupConfig;
  final Widget Function(T option)? optionBuilder;
  final String Function(T option)? getOptionLabel;
  final bool Function(T option, String query)? filterOptions;
  final String noOptionsText;
  final String loadingText;
  final Comparator<T>? sortComparator;
  final dynamic initialSelected; // T for single, List<T> for multi

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();

    final state = useAutocompleteSearch<T>(
      options: options,
      initialOptions: initialOptions,
      asyncOptions: asyncOptions,
      debounceDelay: debounceDelay,
      minSearchLength: minSearchLength,
      groupConfig: groupConfig,
      getOptionLabel: getOptionLabel,
      filterOptions: filterOptions,
      sortComparator: sortComparator,
      initialSelected: initialSelected,
    );

    Widget buildOptionTile(T option, bool isSelected) {
      if (optionBuilder != null) return optionBuilder!(option);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (multiple)
              Checkbox(
                value: isSelected,
                onChanged: (_) => state.toggleMulti(option),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            Expanded(
              child: Text(
                getOptionLabel?.call(option) ?? option.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final listWidget = ValueListenableBuilder<String>(
      valueListenable: state.query,
      builder: (context, _, __) {
        final filtered = state.filteredOptions();
        return AutocompleteSearchList<T>(
          filteredOptions: filtered,
          groupedOptions: state.groupedOptions,
          groupConfig: groupConfig,
          expandedGroups: state.expandedGroups,
          isLoading: state.isLoading.value,
          noOptionsText: noOptionsText,
          loadingText: loadingText,
          scrollController: state.scrollController,
          multiple: multiple,
          isSelected: (opt) => multiple
              ? state.isSelectedMulti(opt)
              : state.isSelectedSingle(opt),
          onTapOption: (opt) {
            if (multiple) {
              state.toggleMulti(opt);
            } else {
              Navigator.of(context).pop<T>(opt);
            }
          },
          optionBuilder: buildOptionTile,
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutocompleteSearchHeader(
          controller: searchController,
          hintText: hintText,
          textCapitalization: textCapitalization,
          onChanged: (value) => state.query.value = value,
        ),
        const SizedBox(height: 4),
        Expanded(child: listWidget),
        if (multiple)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Text(
                  '${state.selectedList.value.length} selected',
                  style: Theme.of(context).textTheme.bodyMedium,
                ).expanded(),
                ElevatedButton(
                  onPressed: () => Navigator.of(
                    context,
                  ).pop<List<T>>(state.selectedList.value),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
