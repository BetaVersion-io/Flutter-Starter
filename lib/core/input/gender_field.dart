import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:iconsax/iconsax.dart';
import 'package:betaversion/core/ui/media/media_view.dart';
import 'package:betaversion/theme/constants/app_assets.dart';
import 'package:betaversion/theme/constants/colors.dart';
import 'package:betaversion/theme/constants/typography.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';

/// Generic Gender Field component with FormBuilder integration
///
/// This component provides a highly customizable FormBuilder gender selection field
/// that can be configured with different options, layouts, and styling.
/// Supports radio buttons, dropdown, chip selection, and custom builders.
class InputGenderField<T> extends StatelessWidget {
  const InputGenderField({
    required this.name,
    required this.options,
    super.key,
    this.label,
    this.fieldType = GenderFieldType.radio,
    this.orientation = OptionsOrientation.horizontal,
    this.validators,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.labelStyle,
    this.showLabel = true,
    this.errorText,
    this.contentPadding,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius,
    this.spacing = 16.0,
    this.runSpacing = 8.0,
  });

  /// Factory constructor for default Male/Female gender selection
  factory InputGenderField.defaultGender({
    required String name,
    Key? key,
    String? label = 'Gender',
    GenderFieldType fieldType = GenderFieldType.radio,
    OptionsOrientation orientation = OptionsOrientation.horizontal,
    List<FormFieldValidator<String>>? additionalValidators,
    bool required = false,
  }) {
    return InputGenderField<String>(
          key: key,
          name: name,
          label: label,
          fieldType: fieldType,
          orientation: orientation,
          options: const [
            GenderOption<String>(
              value: 'Male',
              label: 'Male',
              icon: Iconsax.man,
            ),
            GenderOption<String>(
              value: 'Female',
              label: 'Female',
              icon: Iconsax.woman,
            ),
          ],
          validators: [
            if (required)
              FormBuilderValidators.required(
                errorText: 'Please select your gender',
              ),
            ...?additionalValidators,
          ],
        )
        as InputGenderField<T>;
  }

  /// Factory constructor for custom options
  factory InputGenderField.custom({
    required String name,
    required List<GenderOption<T>> options,
    Key? key,
    String? label,
    GenderFieldType fieldType = GenderFieldType.radio,
    OptionsOrientation orientation = OptionsOrientation.horizontal,
    List<FormFieldValidator<T>>? validators,
  }) {
    return InputGenderField<T>(
      key: key,
      name: name,
      label: label,
      options: options,
      fieldType: fieldType,
      orientation: orientation,
      validators: validators,
    );
  }
  final String name;
  final String? label;
  final List<GenderOption<T>> options;
  final GenderFieldType fieldType;
  final OptionsOrientation orientation;
  final List<FormFieldValidator<T>>? validators;
  final bool enabled;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final void Function(T?)? onSaved;
  final TextStyle? labelStyle;
  final bool showLabel;
  final String? errorText;
  final EdgeInsets? contentPadding;
  final Color? selectedColor;
  final Color? unselectedColor;
  final BorderRadius? borderRadius;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(label!, style: labelStyle ?? AppTypography.bodyMediumMedium),
          const SizedBox(height: 8),
        ],
        _buildField(context),
      ],
    );
  }

  Widget _buildField(BuildContext context) {
    switch (fieldType) {
      case GenderFieldType.radio:
        return _buildRadioGroup(context);
      case GenderFieldType.dropdown:
        return _buildDropdown(context);
      case GenderFieldType.chips:
        return _buildChips(context);
    }
  }

  Widget _buildRadioGroup(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      enabled: enabled,
      initialValue: initialValue,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: FormBuilderValidators.compose(validators ?? []),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (orientation == OptionsOrientation.horizontal)
              Row(children: _buildGenderOptions(context, field))
            else
              Column(children: _buildGenderOptions(context, field)),
            if (field.hasError) ...[
              Text(
                field.errorText ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ).padding(top: 8),
            ],
          ],
        );
      },
    );
  }

  List<Widget> _buildGenderOptions(
    BuildContext context,
    FormFieldState<T> field,
  ) {
    return options.asMap().entries.map((entry) {
      final index = entry.key;
      final option = entry.value;
      final isSelected = field.value == option.value;

      Widget optionWidget = GestureDetector(
        onTap: enabled ? () => field.didChange(option.value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding:
              contentPadding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 12.5),
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? _getSelectedColor(option, context)
                  : (unselectedColor ?? Colors.grey[300]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionIcon(option, isSelected),
              SizedBox(width: spacing / 2),
              Text(
                option.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );

      // Add spacing between options
      if (orientation == OptionsOrientation.horizontal) {
        if (index < options.length - 1) {
          return optionWidget.padding(right: spacing).expanded();
        }
        return optionWidget.expanded();
      }

      if (index < options.length - 1) {
        return optionWidget.padding(bottom: runSpacing);
      }
      return optionWidget;
    }).toList();
  }

  Widget _buildOptionIcon(GenderOption<T> option, bool isSelected) {
    // For default Male/Female options, use SVG icons from assets
    if (option.value == 'Male' || option.value == 'Female') {
      final isMale = option.value == 'Male';
      return MediaView.universal(
        path: isMale ? AppAssets.genderMale : AppAssets.genderFemale,
        height: 24,
        width: 24,
        fit: BoxFit.contain,
        mediaTypeEnum: 'SVG',
      );
    }

    // For custom options, use provided icon or fallback
    if (option.icon != null) {
      return Icon(
        option.icon,
        size: 18,
        color: isSelected ? _getSelectedColor(option, null) : null,
      );
    }

    // No icon fallback
    return const SizedBox(width: 18, height: 18);
  }

  Color _getSelectedColor(GenderOption<T> option, BuildContext? context) {
    if (selectedColor != null) return selectedColor!;
    return AppColors.midNightBlue400;
  }

  Widget _buildDropdown(BuildContext context) {
    return FormBuilderDropdown<T>(
      name: name,
      items: options
          .map(
            (option) => DropdownMenuItem<T>(
              value: option.value,
              child: Row(
                children: [
                  if (option.icon != null) ...[
                    Icon(option.icon, size: 18),
                    SizedBox(width: spacing / 2),
                  ],
                  Text(option.label),
                ],
              ),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        hintText: 'Select ${label ?? 'option'}',
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        errorText: errorText,
      ),
      enabled: enabled,
      initialValue: initialValue,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: FormBuilderValidators.compose(validators ?? []),
    );
  }

  Widget _buildChips(BuildContext context) {
    return FormBuilderChoiceChips<T>(
      name: name,
      options: options
          .map(
            (option) => FormBuilderChipOption<T>(
              value: option.value,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (option.icon != null) ...[
                    Icon(option.icon, size: 16),
                    SizedBox(width: spacing / 2),
                  ],
                  Text(option.label),
                ],
              ),
            ),
          )
          .toList(),
      spacing: spacing,
      runSpacing: runSpacing,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        errorText: errorText,
      ),
      enabled: enabled,
      initialValue: initialValue,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: FormBuilderValidators.compose(validators ?? []),
    );
  }
}

/// Enum for different field types
enum GenderFieldType { radio, dropdown, chips }

/// Class to define gender options
class GenderOption<T> {
  const GenderOption({required this.value, required this.label, this.icon});
  final T value;
  final String label;
  final IconData? icon;
}
