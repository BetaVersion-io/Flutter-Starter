import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:betaversion/core/input/autocomplete_types.dart';

class AutocompleteSearchState<T extends AutocompleteOption> {
  AutocompleteSearchState({
    required this.query,
    required this.isLoading,
    required this.asyncData,
    required this.expandedGroups,
    required this.scrollController,
    required this.selectedList,
    required this.getOptionLabel,
    required this.filterOptions,
    required this.groupConfig,
    required this.sortComparator,
    required this.options,
    required this.initialOptions,
    required this.initialSelected,
  });

  final ValueNotifier<String> query;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<List<T>> asyncData;
  final ValueNotifier<Set<String>> expandedGroups;
  final ScrollController scrollController;
  final ValueNotifier<List<T>> selectedList;

  final String Function(T option)? getOptionLabel;
  final bool Function(T option, String query)? filterOptions;
  final GroupConfig? groupConfig;
  final Comparator<T>? sortComparator;
  final List<T>? options;
  final List<T>? initialOptions;
  final dynamic initialSelected; // T for single; List<T> for multi

  List<T> filteredOptions() {
    if (query.value.isEmpty) {
      final base = initialOptions ?? options ?? [];
      return sortComparator != null
          ? (List<T>.from(base)..sort(sortComparator))
          : base;
    }
    if (asyncData.value.isNotEmpty) {
      final base = asyncData.value;
      return sortComparator != null
          ? (List<T>.from(base)..sort(sortComparator))
          : base;
    }
    final sourceOptions = options ?? [];
    final filtered = sourceOptions.where((option) {
      if (filterOptions != null) {
        return filterOptions!(option, query.value);
      }
      final label = getOptionLabel?.call(option) ?? option.label;
      return label.toLowerCase().contains(query.value.toLowerCase());
    }).toList();
    return sortComparator != null ? (filtered..sort(sortComparator)) : filtered;
  }

  Map<String?, List<T>> groupedOptions(List<T> opts) {
    if (groupConfig?.enabled != true) {
      return {null: opts};
    }
    final grouped = <String?, List<T>>{};
    for (final option in opts) {
      final group = option.group;
      grouped.putIfAbsent(group, () => []).add(option);
    }
    return grouped;
  }

  bool isSelectedSingle(T option) {
    if (initialSelected == null) return false;
    return (initialSelected as T).value == option.value;
  }

  bool isSelectedMulti(T option) {
    return selectedList.value.any((e) => e.value == option.value);
  }

  void toggleMulti(T option) {
    final current = List<T>.from(selectedList.value);
    final exists = current.any((e) => e.value == option.value);
    if (exists) {
      current.removeWhere((e) => e.value == option.value);
    } else {
      current.add(option);
    }
    selectedList.value = current;
  }
}

AutocompleteSearchState<T> useAutocompleteSearch<T extends AutocompleteOption>({
  required List<T>? options,
  required List<T>? initialOptions,
  required Future<List<T>> Function(String, {CancelToken? cancelToken})?
  asyncOptions,
  required Duration debounceDelay,
  required int minSearchLength,
  required GroupConfig? groupConfig,
  required String Function(T option)? getOptionLabel,
  required bool Function(T option, String query)? filterOptions,
  required Comparator<T>? sortComparator,
  required dynamic initialSelected,
}) {
  final query = useState('');
  final isLoading = useState(false);
  final asyncData = useState<List<T>>([]);
  final expandedGroups = useState<Set<String>>(
    groupConfig?.initiallyExpanded ?? {},
  );
  final scrollController = useScrollController();
  final selectedList = useState<List<T>>(
    initialSelected is List<T> ? List<T>.from(initialSelected) : <T>[],
  );

  final cancelTokenRef = useRef<CancelToken?>(null);

  useEffect(() {
    if (asyncOptions == null) return null;
    Timer? timer;
    timer = Timer(debounceDelay, () async {
      if (query.value.length >= minSearchLength) {
        cancelTokenRef.value?.cancel();
        cancelTokenRef.value = CancelToken();
        isLoading.value = true;
        try {
          final results = await asyncOptions(
            query.value,
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
  }, [query.value]);

  return AutocompleteSearchState<T>(
    query: query,
    isLoading: isLoading,
    asyncData: asyncData,
    expandedGroups: expandedGroups,
    scrollController: scrollController,
    selectedList: selectedList,
    getOptionLabel: getOptionLabel,
    filterOptions: filterOptions,
    groupConfig: groupConfig,
    sortComparator: sortComparator,
    options: options,
    initialOptions: initialOptions,
    initialSelected: initialSelected,
  );
}
