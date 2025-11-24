import 'package:betaversion/core/form/hook_form.dart';
import 'package:betaversion/core/input/password_field.dart';
import 'package:betaversion/core/input/text_field.dart';
import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/core/ui/icons/app_icon.dart';
import 'package:betaversion/features/auth/domain/models/register_request.dart';
import 'package:betaversion/features/auth/providers/auth_providers.dart';
import 'package:betaversion/hooks/form/use_form_mutation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';

/// Register screen for user registration
class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final theme = Theme.of(context);

    // Register mutation with form handling
    final formMutation = useFormMutation<void, RegisterRequest>(
      defaultValues: {
        'name': '',
        'email': '',
        'password': '',
        'confirm_password': '',
      },
      transformVariables: (formData) => RegisterRequest(
        name: formData['name'] as String,
        email: formData['email'] as String,
        password: formData['password'] as String,
      ),
      mutationFn: authRepository.register,
      successMessage: 'Registration successful!',
      errorMessage: 'Failed to register. Please try again.',
    );

    return AppScaffold.gradient(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: HookForm(
          form: formMutation.form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(40),

              // App Logo or Title
              const AppIcon(size: 60),
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
              const Gap(48),

              // Name Field (Required)
              InputTextField(
                name: 'name',
                label: 'Full Name',
                hintText: 'Enter your full name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                prefixIcon: Iconsax.profile_2user,
                enabled: !formMutation.isSubmitting,
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(errorText: 'Name is required'),
                ],
              ),
              const Gap(16),

              // Email Field
              InputTextField(
                name: 'email',
                label: 'Email',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefixIcon: Iconsax.card,
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

              // Password Field
              InputPasswordField(
                name: 'password',
                textInputAction: TextInputAction.next,
                enabled: !formMutation.isSubmitting,
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
              InputPasswordField(
                name: 'confirm_password',
                label: 'Confirm Password',
                hintText: 'Re-enter your password',
                enabled: !formMutation.isSubmitting,
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
              const Gap(24),

              // Register Button using form submit button
              formMutation.form.submitButton(
                text: 'Create Account',
                expanded: true,
              ),
              const Gap(16),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const Gap(16),

              // Login Button
              AppButton(
                text: 'Already have an account?',
                disabled: formMutation.isSubmitting,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                variant: AppButtonVariant.text,
              ),
              const Gap(24),

              // Terms & Privacy
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
