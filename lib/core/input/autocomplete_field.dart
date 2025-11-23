import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:betaversion/core/input/autocomplete_search_bottom_sheet.dart';
import 'package:betaversion/core/input/autocomplete_types.dart';

/// Simple implementation of AutocompleteOption
class SimpleOption implements AutocompleteOption {
  const SimpleOption({
    required this.label,
    required this.value,
    this.group,
    this.data,
  });
  @override
  final String label;
  @override
  final dynamic value;
  @override
  final String? group;
  final Map<String, dynamic>? data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleOption &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

/// Generic Autocomplete Field with extensive customization options
class AutocompleteField<T extends AutocompleteOption> extends HookWidget {
  const AutocompleteField({
    required this.name,
    super.key,
    this.label,
    this.hintText = 'Type to search...',
    this.helperText,
    this.multiple = false,
    this.options,
    this.asyncOptions,
    this.initialOptions,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.minSearchLength = 0,
    this.validators,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
    this.optionBuilder,
    this.selectedBuilder,
    this.getOptionLabel,
    this.filterOptions,
    this.groupConfig,
    this.showLabel = true,
    this.labelStyle,
    this.contentPadding,
    this.prefixIcon,
    this.errorText,
    this.clearable = true,
    this.closeOnSelect = true,
    this.maxSelections,
    this.noOptionsText = 'No options',
    this.loadingText = 'Loading...',
    this.autoFocus = false,
    this.disableCloseOnSelect = false,
    this.freeSolo = false,
    this.endAdornment,
    this.sortComparator,
    this.textCapitalization = TextCapitalization.none,
    this.useBottomSheet = false,
    this.bottomSheetTitle,
  }) : assert(
         options != null || asyncOptions != null,
         'Either options or asyncOptions must be provided',
       );
  final String name;
  final String? label;
  final String? hintText;
  final String? helperText;
  final bool multiple;
  final List<T>? options;
  final Future<List<T>> Function(String query, {CancelToken? cancelToken})?
  asyncOptions;
  // Optional initial options to show when query is empty (e.g., recent items)
  final List<T>? initialOptions;
  final Duration debounceDelay;
  final int minSearchLength;
  final List<FormFieldValidator<dynamic>>? validators;
  final bool enabled;
  final dynamic initialValue;
  final void Function(dynamic)? onChanged;
  final Widget Function(T option)? optionBuilder;
  final Widget Function(T option)? selectedBuilder;
  final String Function(T option)? getOptionLabel;
  final bool Function(T option, String query)? filterOptions;
  final GroupConfig? groupConfig;
  final bool showLabel;
  final TextStyle? labelStyle;
  final EdgeInsets? contentPadding;
  final Widget? prefixIcon;
  final String? errorText;
  final bool clearable;
  final bool closeOnSelect;
  final int? maxSelections;
  final String? noOptionsText;
  final String? loadingText;
  final bool autoFocus;
  final bool disableCloseOnSelect;
  final bool freeSolo;
  final Widget? endAdornment;
  final Comparator<T>? sortComparator;
  final TextCapitalization textCapitalization;
  final bool useBottomSheet;
  final String? bottomSheetTitle;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final selectedValue = useState<dynamic>(initialValue);
    final isDropdownOpen = useState(false);
    final focusNode = useFocusNode();
    final isLoading = useState(false);
    final asyncData = useState<List<T>>([]);
    final expandedGroups = useState<Set<String>>(
      groupConfig?.initiallyExpanded ?? {},
    );
    final scrollController = useScrollController();

    // Cancel token for async operations
    final cancelTokenRef = useRef<CancelToken?>(null);

    // Debounced search
    useEffect(() {
      if (asyncOptions == null) return null;

      Timer? timer;
      timer = Timer(debounceDelay, () async {
        if (searchQuery.value.length >= minSearchLength) {
          cancelTokenRef.value?.cancel();
          cancelTokenRef.value = CancelToken();

          isLoading.value = true;
          try {
            final results = await asyncOptions!(
              searchQuery.value,
              cancelToken: cancelTokenRef.value,
            );
            asyncData.value = results;
          } catch (e) {
            if (e is! DioException || !e.type.name.contains('cancel')) {
              asyncData.value = [];
            }
          } finally {
            isLoading.value = false;
          }
        } else {
          asyncData.value = [];
        }
      });

      return () {
        timer?.cancel();
        cancelTokenRef.value?.cancel();
      };
    }, [searchQuery.value]);

    // Get filtered options
    List<T> getFilteredOptions() {
      // If query is empty, prefer explicitly provided initialOptions
      if (searchQuery.value.isEmpty) {
        final base = initialOptions ?? options ?? [];
        return sortComparator != null
            ? (List<T>.from(base)..sort(sortComparator))
            : base;
      }

      // If async options are provided, rely on async results for non-empty queries
      if (asyncOptions != null) {
        final base = asyncData.value;
        return sortComparator != null
            ? (List<T>.from(base)..sort(sortComparator))
            : base;
      }

      // Otherwise filter static options
      final sourceOptions = options ?? [];
      final filtered = sourceOptions.where((option) {
        if (filterOptions != null) {
          return filterOptions!(option, searchQuery.value);
        }
        final label = getOptionLabel?.call(option) ?? option.label;
        return label.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();

      return sortComparator != null
          ? (filtered..sort(sortComparator))
          : filtered;
    }

    // Group options by their group property
    Map<String?, List<T>> getGroupedOptions(List<T> options) {
      if (groupConfig?.enabled != true) {
        return {null: options};
      }

      final grouped = <String?, List<T>>{};
      for (final option in options) {
        final group = option.group;
        grouped.putIfAbsent(group, () => []).add(option);
      }
      return grouped;
    }

    // Handle option selection
    void selectOption(T option, FormFieldState<dynamic> field) {
      if (multiple) {
        final currentList = List<T>.from(
          selectedValue.value is List ? selectedValue.value : [],
        );

        if (currentList.any((item) => item.value == option.value)) {
          currentList.removeWhere((item) => item.value == option.value);
        } else {
          if (maxSelections == null || currentList.length < maxSelections!) {
            currentList.add(option);
          }
        }

        selectedValue.value = currentList;
        field.didChange(currentList);
        onChanged?.call(currentList);

        if (!disableCloseOnSelect && closeOnSelect) {
          searchController.clear();
          searchQuery.value = '';
        }
      } else {
        selectedValue.value = option;
        field.didChange(option);
        onChanged?.call(option);
        searchController.text = getOptionLabel?.call(option) ?? option.label;

        if (closeOnSelect) {
          isDropdownOpen.value = false;
          focusNode.unfocus();
        }
      }
    }

    // Clear selection
    void clearSelection(FormFieldState<dynamic> field) {
      selectedValue.value = multiple ? [] : null;
      field.didChange(multiple ? [] : null);
      onChanged?.call(multiple ? [] : null);
      searchController.clear();
      searchQuery.value = '';
    }

    // Remove a single item from multiple selection
    void removeItem(T item, FormFieldState<dynamic> field) {
      if (!multiple) return;

      final currentList = List<T>.from(selectedValue.value);
      currentList.removeWhere((option) => option.value == item.value);
      selectedValue.value = currentList;
      field.didChange(currentList);
      onChanged?.call(currentList);
    }

    // Focus listener (only for inline dropdown mode)
    useEffect(() {
      void listener() {
        if (!useBottomSheet && !focusNode.hasFocus) {
          Future.delayed(const Duration(milliseconds: 200), () {
            isDropdownOpen.value = false;
          });
        }
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    // Update text field when single selection changes
    useEffect(() {
      if (!multiple && selectedValue.value != null) {
        final option = selectedValue.value as T;
        searchController.text = getOptionLabel?.call(option) ?? option.label;
      }
      return null;
    }, [selectedValue.value]);

    // Build option widget
    Widget buildOptionWidget(
      T option,
      bool isSelected,
      FormFieldState<dynamic> field,
    ) {
      if (optionBuilder != null) {
        return optionBuilder!(option);
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (multiple)
              Checkbox(
                value: isSelected,
                onChanged: (_) => selectOption(option, field),
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

    // Build selected chips for multiple selection
    Widget buildSelectedChips(FormFieldState<dynamic> field) {
      if (!multiple ||
          selectedValue.value == null ||
          selectedValue.value.isEmpty) {
        return const SizedBox.shrink();
      }

      final selectedList = selectedValue.value as List<T>;

      return Wrap(
        spacing: 8,
        runSpacing: 4,
        children: selectedList.map((option) {
          if (selectedBuilder != null) {
            return selectedBuilder!(option);
          }

          return Chip(
            label: Text(
              getOptionLabel?.call(option) ?? option.label,
              style: const TextStyle(fontSize: 12),
            ),
            onDeleted: enabled ? () => removeItem(option, field) : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            deleteIconColor: Theme.of(context).hintColor,
          );
        }).toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(label!, style: labelStyle ?? AppTypography.bodyMediumMedium),
          const Gap(8),
        ],
        FormBuilderField<dynamic>(
          name: name,
          initialValue: initialValue,
          enabled: enabled,
          validator: validators != null
              ? FormBuilderValidators.compose(validators!)
              : null,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selected chips for multiple selection
                if (multiple) ...[
                  buildSelectedChips(field),
                  if (selectedValue.value != null &&
                      (selectedValue.value as List).isNotEmpty)
                    const Gap(8),
                ],

                // Search input field
                TextField(
                  controller: searchController,
                  focusNode: focusNode,
                  enabled: enabled,
                  autofocus: autoFocus,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: textCapitalization,
                  readOnly: useBottomSheet,
                  decoration: InputDecoration(
                    hintText: hintText,
                    helperText: helperText,
                    errorText: errorText ?? field.errorText,
                    prefixIcon: prefixIcon,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLoading.value)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else if (clearable &&
                            ((multiple &&
                                    selectedValue.value != null &&
                                    (selectedValue.value as List).isNotEmpty) ||
                                (!multiple && selectedValue.value != null)))
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: enabled
                                ? () => clearSelection(field)
                                : null,
                          )
                        else
                          const Icon(Icons.arrow_drop_down, size: 20),
                        if (endAdornment != null) endAdornment!,
                      ],
                    ),
                    contentPadding:
                        contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                  ),
                  onChanged: (value) {
                    searchQuery.value = value;
                    if (value.isEmpty && !multiple) {
                      selectedValue.value = null;
                      field.didChange(null);
                    }
                  },
                  onTap: () async {
                    if (useBottomSheet) {
                      final result =
                          await AutocompleteSearchBottomSheet.show<T>(
                            context: context,
                            title: bottomSheetTitle ?? label ?? 'Select',
                            hintText: hintText,
                            textCapitalization: textCapitalization,
                            multiple: multiple,
                            options: options,
                            initialOptions: initialOptions,
                            asyncOptions: asyncOptions,
                            debounceDelay: debounceDelay,
                            minSearchLength: minSearchLength,
                            groupConfig: groupConfig,
                            optionBuilder: optionBuilder,
                            getOptionLabel: getOptionLabel,
                            filterOptions: filterOptions,
                            noOptionsText: noOptionsText!,
                            loadingText: loadingText!,
                            sortComparator: sortComparator,
                            initialSelected: selectedValue.value,
                          );
                      if (result != null) {
                        if (!multiple && result is T) {
                          selectOption(result, field);
                        } else if (multiple && result is List<T>) {
                          // Replace current list with the returned one
                          selectedValue.value = result;
                          field.didChange(result);
                          onChanged?.call(result);
                        }
                      }
                    } else {
                      isDropdownOpen.value = true;
                    }
                  },
                ),

                // Dropdown options
                if (!useBottomSheet && isDropdownOpen.value) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: _buildDropdownContent(
                        context: context,
                        isLoading: isLoading.value,
                        filteredOptions: getFilteredOptions(),
                        groupedOptions: getGroupedOptions,
                        selectedValue: selectedValue.value,
                        multiple: multiple,
                        selectOption: (option) => selectOption(option, field),
                        buildOptionWidget: (option, isSelected) =>
                            buildOptionWidget(option, isSelected, field),
                        expandedGroups: expandedGroups,
                        groupConfig: groupConfig,
                        noOptionsText: noOptionsText!,
                        loadingText: loadingText!,
                        scrollController: scrollController,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  // Inline bottom sheet implementation removed in favor of
  // dedicated AutocompleteSearchBottomSheet component.

  Widget _buildDropdownContent({
    required BuildContext context,
    required bool isLoading,
    required List<T> filteredOptions,
    required Map<String?, List<T>> Function(List<T>) groupedOptions,
    required dynamic selectedValue,
    required bool multiple,
    required void Function(T) selectOption,
    required Widget Function(T, bool) buildOptionWidget,
    required ValueNotifier<Set<String>> expandedGroups,
    required GroupConfig? groupConfig,
    required String noOptionsText,
    required String loadingText,
    required ScrollController scrollController,
  }) {
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

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: grouped.entries
          .map((e) => (e.key != null ? 1 : 0) + e.value.length)
          .reduce((a, b) => a + b),
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
              final isSelected = multiple
                  ? (selectedValue as List?)?.any(
                          (item) => item.value == option.value,
                        ) ??
                        false
                  : selectedValue?.value == option.value;

              return InkWell(
                onTap: () => selectOption(option),
                child: buildOptionWidget(option, isSelected),
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
