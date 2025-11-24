import 'package:betaversion/core/form/hook_form.dart';
import 'package:betaversion/core/input/password_field.dart';
import 'package:betaversion/core/input/text_field.dart';
import 'package:betaversion/core/layout/app_scaffold/app_scaffold.dart';
import 'package:betaversion/core/ui/button/app_button/app_button.dart';
import 'package:betaversion/core/ui/icons/app_icon.dart';
import 'package:betaversion/features/auth/domain/models/login_request.dart';
import 'package:betaversion/features/auth/providers/auth_providers.dart';
import 'package:betaversion/hooks/form/use_form_mutation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';

/// Login screen for user authentication
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final theme = Theme.of(context);

    // Login mutation with form handling
    final formMutation = useFormMutation<void, LoginRequest>(
      defaultValues: {'email': '', 'password': '', 'remember_me': false},
      transformVariables: (formData) => LoginRequest(
        email: formData['email'] as String,
        password: formData['password'] as String,
        rememberMe: formData['remember_me'] as bool? ?? false,
      ),
      mutationFn: authRepository.login,
      successMessage: 'Login successful!',
      errorMessage: 'Failed to login. Please check your credentials.',
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
                'Welcome Back',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'Sign in to continue',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(32),

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
                enabled: !formMutation.isSubmitting,
                validators: [
                  FormBuilderValidators.required(
                    errorText: 'Password is required',
                  ),
                  FormBuilderValidators.minLength(
                    6,
                    errorText: 'Password must be at least 6 characters',
                  ),
                ],
              ),
              const Gap(12),

              // Remember Me & Forgot Password Row
              Row(
                mainAxisAlignment: .end,
                children: [
                  AppButton(
                    text: 'Forgot Password?',
                    variant: AppButtonVariant.text,
                    size: AppButtonSize.small,
                    disabled: formMutation.isSubmitting,
                    onPressed: () {
                      // Navigate to forgot password screen
                    },
                  ),
                ],
              ),
              const Gap(24),

              // Login Button using form submit button
              formMutation.form.submitButton(
                text: 'Login',
                // customTextColor: Colors.black,
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

              // Register Button
              AppButton(
                text: 'Create Account',
                disabled: formMutation.isSubmitting,
                onPressed: () {
                  // Navigate to register screen
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
