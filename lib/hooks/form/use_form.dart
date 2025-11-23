import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Custom hook for form management similar to React Hook Form
/// Leverages FormBuilder's internal state management to avoid unnecessary re-renders
class UseFormReturn {
  const UseFormReturn({
    required this.formKey,
    required this.isSubmitting,
    required this.reset,
    required this.resetField,
    required this.handleSubmit,
    required this.setValue,
    required this.getValue,
    required this.setError,
    required this.clearErrors,
    required this.validate,
    required this.setValues,
    required this.getValues,
    required this.getErrors,
    required this.isDirty,
    required this.isValid,
  });
  final GlobalKey<FormBuilderState> formKey;
  final bool isSubmitting;
  final VoidCallback reset;
  final void Function(String name) resetField;
  final Future<void> Function() handleSubmit;
  final void Function(String name, dynamic value) setValue;
  final dynamic Function(String name) getValue;
  final void Function(String name, String? error) setError;
  final void Function() clearErrors;
  final bool Function() validate;
  final void Function(Map<String, dynamic> values) setValues;
  final Map<String, dynamic> Function() getValues;
  final Map<String, String?> Function() getErrors;
  final bool Function() isDirty;
  final bool Function() isValid;
}

/// Custom hook for form management that leverages FormBuilder's state
///
/// Example usage:
/// ```dart
/// final form = useForm(
///   defaultValues: {
///     'email': '',
///     'password': '',
///   },
///   onSubmit: (data) async {
///     // Handle form submission
///     await api.submitData(data);
///   },
/// );
///
/// // In your widget tree
/// FormBuilder(
///   key: form.formKey,
///   initialValue: form.defaultValues,
///   child: Column(
///     children: [
///       FormBuilderTextField(
///         name: 'email',
///       ),
///       ElevatedButton(
///         onPressed: form.onSubmit,
///         child: form.isSubmitting
///           ? CircularProgressIndicator()
///           : Text('Submit'),
///       ),
///     ],
///   ),
/// )
/// ```
UseFormReturn useForm({
  Map<String, dynamic>? defaultValues,
  Future<void> Function(Map<String, dynamic>)? onSubmit,
  bool validateOnChange = false,
  bool validateOnBlur = false,
}) {
  final formKey = useMemoized(GlobalKey<FormBuilderState>.new);
  final isSubmitting = useState(false);
  final initialValues = useMemoized(() => defaultValues ?? {});

  // Get current form values from FormBuilder
  Map<String, dynamic> getValues() {
    return formKey.currentState?.value ?? initialValues;
  }

  // Get current errors from FormBuilder
  Map<String, String?> getErrors() {
    final fields = formKey.currentState?.fields;
    if (fields == null) return {};

    final errors = <String, String?>{};
    fields.forEach((name, field) {
      if (field.hasError) {
        errors[name] = field.errorText;
      }
    });
    return errors;
  }

  // Check if form is dirty by comparing with initial values
  bool isDirty() {
    final currentValues = getValues();
    if (currentValues.length != initialValues.length) return true;

    for (final key in initialValues.keys) {
      if (currentValues[key] != initialValues[key]) return true;
    }
    return false;
  }

  // Check if form is valid
  bool isValid() {
    return formKey.currentState?.isValid ?? false;
  }

  // Validate form
  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  // Set single value
  void setValue(String name, dynamic value) {
    formKey.currentState?.fields[name]?.didChange(value);

    if (validateOnChange) {
      validate();
    }
  }

  // Set multiple values
  void setValues(Map<String, dynamic> newValues) {
    newValues.forEach((name, value) {
      formKey.currentState?.fields[name]?.didChange(value);
    });

    if (validateOnChange) {
      validate();
    }
  }

  // Get single value
  dynamic getValue(String name) {
    return formKey.currentState?.fields[name]?.value ??
        formKey.currentState?.value[name] ??
        initialValues[name];
  }

  // Set error for specific field
  void setError(String name, String? error) {
    if (error != null) {
      formKey.currentState?.fields[name]?.invalidate(error);
    } else {
      formKey.currentState?.fields[name]?.validate();
    }
  }

  // Clear all errors
  void clearErrors() {
    formKey.currentState?.fields.forEach((name, field) {
      field.validate();
    });
  }

  // Reset form to initial values
  void reset() {
    formKey.currentState?.reset();
  }

  // Reset specific field
  void resetField(String name) {
    formKey.currentState?.fields[name]?.reset();
  }

  // Handle form submission with callback
  Future<void> handleSubmit() async {
    // Save and validate form
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isSubmitting.value = true;

      try {
        final formData = formKey.currentState!.value;
        await onSubmit?.call(formData);
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  // Direct form submission method
  // Future<void> handleOnSubmit() async {
  //   if (onSubmit == null) return;

  //   // Save and validate form
  //   if (formKey.currentState?.saveAndValidate() ?? false) {
  //     isSubmitting.value = true;

  //     try {
  //       final formData = formKey.currentState!.value;
  //       await onSubmit(formData);
  //     } finally {
  //       isSubmitting.value = false;
  //     }
  //   }
  // }

  return UseFormReturn(
    formKey: formKey,
    isSubmitting: isSubmitting.value,
    reset: reset,
    resetField: resetField,
    handleSubmit: handleSubmit,
    setValue: setValue,
    getValue: getValue,
    setError: setError,
    clearErrors: clearErrors,
    validate: validate,
    setValues: setValues,
    getValues: getValues,
    getErrors: getErrors,
    isDirty: isDirty,
    isValid: isValid,
  );
}
