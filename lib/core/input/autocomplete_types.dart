import 'package:flutter/material.dart';

/// Base class for autocomplete options
abstract class AutocompleteOption {
  String get label;
  dynamic get value;
  String? get group;
}

/// Configuration for grouped display
class GroupConfig {
  final bool enabled;
  final Widget Function(String groupName)? groupHeaderBuilder;
  final bool collapsible;
  final Set<String> initiallyExpanded;

  const GroupConfig({
    this.enabled = true,
    this.groupHeaderBuilder,
    this.collapsible = false,
    this.initiallyExpanded = const {},
  });
}
