import 'package:betaversion/core/form/hook_form.dart';
import 'package:betaversion/core/input/text_field.dart';
import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/features/auth/domain/models/register_request.dart';
import 'package:betaversion/features/auth/providers/auth_providers.dart';
import 'package:betaversion/hooks/form/use_form_mutation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Register screen for user registration
class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);
    final authRepository = ref.watch(authRepositoryProvider);
    final theme = Theme.of(context);

    // Register mutation with form handling
    final formMutation = useFormMutation<void, RegisterRequest>(
      defaultValues: {
        'name': '',
        'email': '',
        'phone_number': '',
        'password': '',
        'confirm_password': '',
        'accept_terms': false,
      },
      transformVariables: (formData) => RegisterRequest(
        email: formData['email'] as String,
        password: formData['password'] as String,
        name: (formData['name'] as String?)?.isNotEmpty ?? false
            ? formData['name'] as String?
            : null,
        phoneNumber: (formData['phone_number'] as String?)?.isNotEmpty ?? false
            ? formData['phone_number'] as String?
            : null,
      ),
      mutationFn: authRepository.register,
      successMessage: 'Registration successful!',
      errorMessage: 'Failed to register. Please try again.',
    );

    return AppScaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: HookForm(
          form: formMutation.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(24),

              // Welcome Text
              Text(
                'Join Us Today',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'Create your account to get started',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(40),

              // Name Field (Optional)
              InputTextField(
                name: 'name',
                label: 'Full Name (Optional)',
                hintText: 'Enter your full name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.person_outlined,
                enabled: !formMutation.isSubmitting,
                textCapitalization: TextCapitalization.words,
              ),
              const Gap(16),

              // Email Field
              InputTextField(
                name: 'email',
                label: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.email_outlined,
                enabled: !formMutation.isSubmitting,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Email is required',
                  ),
                  FormBuilderValidators.email(
                    errorText: 'Please enter a valid email',
                  ),
                ],
              ),
              const Gap(16),

              // Phone Number Field (Optional)
              InputTextField(
                name: 'phone_number',
                label: 'Phone Number (Optional)',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.phone_outlined,
                enabled: !formMutation.isSubmitting,
                validators: [
                  FormBuilderValidators.numeric(
                    errorText: 'Please enter a valid phone number',
                  ),
                ],
              ),
              const Gap(16),

              // Password Field
              InputTextField(
                name: 'password',
                label: 'Password',
                hintText: 'Enter your password',
                obscureText: obscurePassword.value,
                textInputAction: TextInputAction.next,
                prefixIcon: Icons.lock_outlined,
                enabled: !formMutation.isSubmitting,
                suffix: IconButton(
                  icon: Icon(
                    obscurePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    obscurePassword.value = !obscurePassword.value;
                  },
                ),
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Password is required',
                  ),
                  FormBuilderValidators.minLength(
                    8,
                    errorText: 'Password must be at least 8 characters',
                  ),
                  (value) {
                    if (value == null || value.isEmpty) return null;
                    final hasUppercase = value.contains(RegExp('[A-Z]'));
                    final hasLowercase = value.contains(RegExp('[a-z]'));
                    final hasDigit = value.contains(RegExp(r'\d'));
                    if (!hasUppercase || !hasLowercase || !hasDigit) {
                      return 'Password must contain uppercase, lowercase and number';
                    }
                    return null;
                  },
                ],
              ),
              const Gap(16),

              // Confirm Password Field
              InputTextField(
                name: 'confirm_password',
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                obscureText: obscureConfirmPassword.value,
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.lock_outlined,
                enabled: !formMutation.isSubmitting,
                suffix: IconButton(
                  icon: Icon(
                    obscureConfirmPassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    obscureConfirmPassword.value =
                        !obscureConfirmPassword.value;
                  },
                ),
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Please confirm your password',
                  ),
                  (value) {
                    final password = formMutation.form.getValue('password');
                    if (value != password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ],
              ),
              const Gap(16),

              // Terms & Conditions Checkbox
              // InputTextField(
              //   name: 'accept_terms',
              //   label: 'I agree to the Terms & Conditions and Privacy Policy',
              //   enabled: !formMutation.isSubmitting,
              //   validators: [
              //     FormBuilderValidators.equal(
              //       true,
              //       errorText: 'You must accept the terms and conditions',
              //     ),
              //   ],
              // ),
              const Gap(32),

              // Register Button using form submit button
              formMutation.form.submitButton(
                text: 'Create Account',
                expanded: true,
              ),
              const Gap(24),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  TextButton(
                    onPressed: formMutation.isSubmitting
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: Text(
                      'Login',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
