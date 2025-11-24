import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/hooks/form/use_form.dart';
import 'package:betaversion/theme/extensions/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';

/// A reusable Form component that combines FormBuilder with custom UseFormReturn
///
/// This widget provides a consistent form structure across the application
/// by leveraging FormBuilder's state management and our custom form hooks.
///
/// Example usage:
/// ```dart
/// final form = useForm(
///   defaultValues: {'email': '', 'password': ''},
///   onSubmit: (data) async {
///     // Handle submission
///   },
/// );
///
/// return Form(
///   form: form,
///   child: Column(
///     children: [
///       FormBuilderTextField(name: 'email'),
///       FormBuilderTextField(name: 'password'),
///       ElevatedButton(
///         onPressed: form.handleSubmit,
///         child: Text('Submit'),
///       ),
///     ],
///   ),
/// );
/// ```
class HookForm extends StatelessWidget {
  final UseFormReturn form;
  final Widget child;
  final Map<String, dynamic>? initialValue;
  final bool enabled;
  final VoidCallback? onChanged;
  final AutovalidateMode? autovalidateMode;
  final Map<String, Function(String?)>? validators;
  final bool skipDisabled;
  final bool clearValueOnUnregister;

  const HookForm({
    super.key,
    required this.form,
    required this.child,
    this.initialValue,
    this.enabled = true,
    this.onChanged,
    this.autovalidateMode,
    this.validators,
    this.skipDisabled = false,
    this.clearValueOnUnregister = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: form.formKey,
      initialValue: initialValue ?? form.getValues(),
      enabled: enabled,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      skipDisabled: skipDisabled,
      clearValueOnUnregister: clearValueOnUnregister,
      child: child,
    );
  }
}

/// Extension to provide additional form-related widgets
extension FormExtensions on UseFormReturn {
  /// Creates a submit button with built-in loading state
  Widget submitButton({
    required String text,
    bool disabled = false,
    AppButtonVariant variant = AppButtonVariant.contained,
    AppButtonSize size = AppButtonSize.medium,
    AppButtonSeverity severity = AppButtonSeverity.primary,
    IconData? icon,
    IconData? endIcon,
    double? width = double.infinity,
    double? height,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    double? borderRadius,
    double? elevation,
    Color? customColor,
    Color? customTextColor,
    double? borderWidth,
    Widget? customChild,
    double? iconSize,
    Color? iconColor,
    bool expanded = false,
    EdgeInsetsGeometry? margin,
  }) {
    return AppButton(
      onPressed: handleSubmit,
      isLoading: isSubmitting,
      text: text,
      disabled: disabled,
      variant: variant,
      size: size,
      severity: severity,
      icon: icon,
      endIcon: endIcon,
      width: width,
      height: height,
      padding: padding,
      textStyle: textStyle,
      borderRadius: borderRadius,
      elevation: elevation,
      customColor: customColor,
      customTextColor: customTextColor,
      borderWidth: borderWidth,
      customChild: customChild,
      iconSize: iconSize,
      iconColor: iconColor,
      expanded: expanded,
      margin: margin,
    );
  }

  /// Creates a reset button
  Widget resetButton({required String text, Widget? icon, ButtonStyle? style}) {
    return TextButton(
      onPressed: isSubmitting ? null : reset,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, const Gap(8)],
          Text(text),
        ],
      ),
    );
  }

  /// Creates a field error widget
  Widget fieldError(String fieldName) {
    final errors = getErrors();
    final error = errors[fieldName];

    if (error == null || error.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      error,
      style: TextStyle(color: Colors.red[700], fontSize: 12),
    ).padding(top: 8);
  }

  /// Creates a form validation summary
  Widget validationSummary() {
    final errors = getErrors();
    final errorList = errors.entries
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .toList();

    if (errorList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please correct the following errors:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const Gap(8),
          ...errorList.map(
            (entry) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.red[700])),
                Expanded(
                  child: Text(
                    entry.value!,
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ],
            ).padding(left: 16, top: 4),
          ),
        ],
      ),
    );
  }
}
