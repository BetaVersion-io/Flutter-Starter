import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:betaversion/theme/constants/typography.dart';

/// Generic Date Field component with FormBuilder integration
///
/// This component provides a highly customizable FormBuilder date field
/// that supports date, time, and datetime selection with various configurations.
/// Supports validation, formatting, styling, and interaction callbacks.
class InputDateField extends StatelessWidget {
  const InputDateField({
    required this.name,
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.inputType = InputType.date,
    this.format,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.validators,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onSaved,
    this.contentPadding,
    this.style,
    this.labelStyle,
    this.showLabel = true,
    this.errorText,
    this.initialTime,
    this.use24hFormat = true,
    this.cancelText,
    this.confirmText,
  });

  /// Factory constructor for date of birth field
  factory InputDateField.dateOfBirth({
    required String name,
    Key? key,
    String? label = 'Date of Birth',
    IconData? prefixIcon = Iconsax.user,
    List<FormFieldValidator<DateTime>>? additionalValidators,
  }) {
    return InputDateField(
      key: key,
      name: name,
      label: label,
      prefixIcon: prefixIcon,
      lastDate: DateTime.now(),
      validators: [
        FormBuilderValidators.required(errorText: 'Date of birth is required'),
        (DateTime? value) {
          if (value != null && value.isAfter(DateTime.now())) {
            return 'Date of birth cannot be in the future';
          }
          return null;
        },
        (DateTime? value) {
          if (value != null) {
            final age = DateTime.now().difference(value).inDays ~/ 365;
            if (age < 18) {
              return 'You must be at least 18 years old';
            }
          }
          return null;
        },
        ...?additionalValidators,
      ],
    );
  }

  /// Factory constructor for appointment/event date field
  factory InputDateField.appointment({
    required String name,
    Key? key,
    String? label = 'Appointment Date',
    IconData? prefixIcon = Iconsax.calendar_2,
    DateTime? minDate,
    List<FormFieldValidator<DateTime>>? additionalValidators,
  }) {
    return InputDateField(
      key: key,
      name: name,
      label: label,
      prefixIcon: prefixIcon,
      inputType: InputType.both,
      firstDate: minDate ?? DateTime.now(),
      validators: [
        FormBuilderValidators.required(
          errorText: 'Please select a date and time',
        ),
        (DateTime? value) {
          if (value != null && value.isBefore(DateTime.now())) {
            return 'Please select a future date';
          }
          return null;
        },
        ...?additionalValidators,
      ],
    );
  }

  /// Factory constructor for time-only field
  factory InputDateField.timeOnly({
    required String name,
    Key? key,
    String? label = 'Time',
    IconData? prefixIcon = Iconsax.clock,
    bool use24hFormat = true,
    List<FormFieldValidator<DateTime>>? additionalValidators,
  }) {
    return InputDateField(
      key: key,
      name: name,
      label: label,
      prefixIcon: prefixIcon,
      inputType: InputType.time,
      use24hFormat: use24hFormat,
      validators: [
        FormBuilderValidators.required(errorText: 'Please select a time'),
        ...?additionalValidators,
      ],
    );
  }
  final String name;
  final String? label;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final InputType inputType;
  final DateFormat? format;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final List<FormFieldValidator<DateTime>>? validators;
  final bool enabled;
  final bool readOnly;
  final void Function(DateTime?)? onChanged;
  final void Function(DateTime?)? onSaved;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final bool showLabel;
  final String? errorText;
  final TimeOfDay? initialTime;
  final bool use24hFormat;
  final String? cancelText;
  final String? confirmText;

  @override
  Widget build(BuildContext context) {
    // Default format based on input type
    DateFormat defaultFormat;
    switch (inputType) {
      case InputType.date:
        defaultFormat = DateFormat('dd/MM/yyyy');
        break;
      case InputType.time:
        defaultFormat = DateFormat('HH:mm');
        break;
      case InputType.both:
        defaultFormat = DateFormat('dd/MM/yyyy HH:mm');
        break;
    }

    // Default suffix icon based on input type
    Widget defaultSuffixIcon;
    switch (inputType) {
      case InputType.date:
        defaultSuffixIcon = const Icon(Iconsax.calendar, size: 20);
        break;
      case InputType.time:
        defaultSuffixIcon = const Icon(Iconsax.clock, size: 20);
        break;
      case InputType.both:
        defaultSuffixIcon = const Icon(Iconsax.calendar_2, size: 20);
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(label!, style: labelStyle ?? AppTypography.bodyMediumMedium),
          const Gap(8),
        ],
        FormBuilderDateTimePicker(
          name: name,
          inputType: inputType,
          format: format ?? defaultFormat,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(2100),
          enabled: enabled,
          onChanged: onChanged,
          onSaved: onSaved,
          initialTime: initialTime ?? const TimeOfDay(hour: 12, minute: 0),
          // use24hFormat: use24hFormat,
          cancelText: cancelText,
          confirmText: confirmText,
          style: style ?? const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            suffixIcon: suffixIcon ?? defaultSuffixIcon,
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: FormBuilderValidators.compose(validators ?? []),
        ),
      ],
    );
  }
}
