import 'dart:async';

import 'package:betaversion/hooks/form/use_form.dart';
import 'package:betaversion/hooks/queries/use_fetch_mutation.dart';
import 'package:betaversion/services/network/api_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:fquery/fquery.dart';

/// Return type for useFormMutation hook that combines form state with mutation capabilities
class UseFormMutationReturn<TData, TVariables> {
  const UseFormMutationReturn({required this.form, required this.mutation});
  final UseFormReturn form;
  final UseMutationResult<TData, ApiException, TVariables> mutation;

  /// Convenience getters from form
  bool get isSubmitting => mutation.isPending;
  bool get isValid => form.isValid();
  bool get isDirty => form.isDirty();
  Map<String, dynamic> getValues() => form.getValues();
  dynamic getValue(String name) => form.getValue(name);
  void setValue(String name, dynamic value) => form.setValue(name, value);
  void reset() => form.reset();

  /// Convenience getters from mutation
  bool get isPending => mutation.isPending;
  bool get isError => mutation.isError;
  bool get isSuccess => mutation.isSuccess;
  TData? get data => mutation.data;
  ApiException? get error => mutation.error;

  /// Submit form with mutation
  Future<void> submit() => form.handleSubmit();

  /// Mutate directly with custom data
  Future<void> mutate(TVariables variables) => mutation.mutate(variables);
}

/// Hook that combines useForm with useFetchMutation for seamless form handling with API calls
///
/// Example usage:
/// ```dart
/// // Basic usage (no transformation needed)
/// final formMutation = useFormMutation<User, Map<String, dynamic>>(
///   defaultValues: {
///     'name': '',
///     'email': '',
///   },
///   mutationFn: (data, {cancelToken}) => api.createUser(data, cancelToken: cancelToken),
///   successMessage: 'User created successfully!',
///   popOnSuccess: true,
/// );
///
/// // With custom transformation
/// final formMutation = useFormMutation<User, CreateUserRequest>(
///   defaultValues: {
///     'name': '',
///     'email': '',
///   },
///   transformVariables: (formData) => CreateUserRequest(
///     name: formData['name'],
///     email: formData['email'],
///   ),
///   mutationFn: (request, {cancelToken}) => api.createUser(request, cancelToken: cancelToken),
/// );
///
/// // In your widget
/// HookForm(
///   form: formMutation.form,
///   child: Column(
///     children: [
///       FormBuilderTextField(name: 'name'),
///       FormBuilderTextField(name: 'email'),
///       formMutation.form.submitButton(text: 'Create User'),
///     ],
///   ),
/// )
/// ```
UseFormMutationReturn<TData, TVariables> useFormMutation<TData, TVariables>({
  required Map<String, dynamic> defaultValues,
  required Future<TData> Function(
    TVariables variables, {
    CancelToken? cancelToken,
  })
  mutationFn,
  FutureOr<TVariables> Function(Map<String, dynamic> formData)?
  transformVariables,

  // Form options
  bool validateOnChange = false,
  bool validateOnBlur = false,

  // Mutation options (from useFetchMutation)
  String? successMessage,
  String Function(TData data, TVariables variables)? dynamicSuccessMessage,
  String? errorMessage,
  String Function(ApiException error, TVariables variables)?
  dynamicErrorMessage,
  bool popOnSuccess = false,
  bool Function(TData data, TVariables variables)? dynamicPopCondition,
  void Function(ApiException, TVariables, dynamic)? onError,
  FutureOr<dynamic> Function(TVariables)? onMutate,
  void Function(TData?, ApiException?, TVariables, dynamic)? onSettled,
  void Function(TData, TVariables, dynamic)? onSuccess,
}) {
  // Use the existing useFetchMutation hook
  final mutation = useFetchMutation<TData, TVariables, dynamic>(
    mutationFn,
    successMessage: successMessage,
    dynamicSuccessMessage: dynamicSuccessMessage,
    errorMessage: errorMessage,
    dynamicErrorMessage: dynamicErrorMessage,
    popOnSuccess: popOnSuccess,
    dynamicPopCondition: dynamicPopCondition,
    onError: onError,
    onMutate: onMutate,
    onSettled: onSettled,
    onSuccess: onSuccess,
  );

  // Use the existing useForm hook with transformation
  final form = useForm(
    defaultValues: defaultValues,
    validateOnChange: validateOnChange,
    validateOnBlur: validateOnBlur,
    onSubmit: (formData) async {
      final variables = transformVariables != null
          ? await transformVariables(formData)
          : formData as TVariables;
      await mutation.mutate(variables);
    },
  );

  return UseFormMutationReturn<TData, TVariables>(
    form: form,
    mutation: mutation,
  );
}
