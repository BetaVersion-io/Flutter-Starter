import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:betaversion/core/input/autocomplete_search/autocomplete_search_content.dart';
import 'package:betaversion/core/input/autocomplete_types.dart';
import 'package:betaversion/core/ui/bottom_sheet/app_bottom_sheet.dart';

/// Minimal API surface for showing the autocomplete search sheet.
/// The full UI lives in AutocompleteSearchContent for separation of concerns.
class AutocompleteSearchBottomSheet {
  static Future<dynamic> show<T extends AutocompleteOption>({
    required BuildContext context,
    required String title,
    String? hintText,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool multiple = false,
    List<T>? options,
    List<T>? initialOptions,
    Future<List<T>> Function(String query, {CancelToken? cancelToken})?
    asyncOptions,
    Duration debounceDelay = const Duration(milliseconds: 300),
    int minSearchLength = 0,
    GroupConfig? groupConfig,
    Widget Function(T option)? optionBuilder,
    String Function(T option)? getOptionLabel,
    bool Function(T option, String query)? filterOptions,
    String noOptionsText = 'No options',
    String loadingText = 'Loading...',
    Comparator<T>? sortComparator,
    dynamic initialSelected,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: title,
      padding: EdgeInsets.zero,
      child: AutocompleteSearchContent<T>(
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
        noOptionsText: noOptionsText,
        loadingText: loadingText,
        sortComparator: sortComparator,
        initialSelected: initialSelected,
      ),
    );
  }
}
