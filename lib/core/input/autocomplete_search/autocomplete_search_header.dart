import 'package:flutter/material.dart';

class AutocompleteSearchHeader extends StatelessWidget {
  const AutocompleteSearchHeader({
    required this.controller,
    required this.hintText,
    required this.textCapitalization,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextCapitalization textCapitalization;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: TextField(
        controller: controller,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
