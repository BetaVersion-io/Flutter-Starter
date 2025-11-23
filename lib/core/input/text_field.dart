import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:betaversion/theme/constants/typography.dart';

/// Generic Text Field component with FormBuilder integration
///
/// This component provides a highly customizable FormBuilder text field
/// that can be configured for different use cases with various options.
/// Supports validation, formatting, styling, and interaction callbacks.
class InputTextField extends StatelessWidget {
  const InputTextField({
    required this.name,
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.validators,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.controller,
    this.focusNode,
    this.contentPadding,
    this.style,
    this.labelStyle,
    this.textCapitalization = TextCapitalization.none,
    this.showLabel = true,
    this.errorText,
    this.prefix,
    this.suffix,
    this.autofocus = false,
  });
  final String name;
  final String? label;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final List<FormFieldValidator<String>>? validators;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? initialValue;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final void Function()? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextCapitalization textCapitalization;
  final bool showLabel;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && label != null) ...[
          Text(label!, style: labelStyle ?? AppTypography.bodyMediumMedium),
          const Gap(8),
        ],
        FormBuilderTextField(
          name: name,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          initialValue: initialValue,
          onChanged: onChanged,
          onSaved: onSaved,
          onTap: onTap,
          controller: controller,
          focusNode: focusNode,
          textCapitalization: textCapitalization,
          style: style ?? const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
            suffixIcon: suffixIcon,
            prefix: prefix,
            suffix: suffix,
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
