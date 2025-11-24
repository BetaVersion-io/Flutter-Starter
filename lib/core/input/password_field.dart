import 'package:betaversion/core/input/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax/iconsax.dart';

/// Password input field with visibility toggle
class InputPasswordField extends HookWidget {
  const InputPasswordField({
    required this.name,
    super.key,
    this.label = 'Password',
    this.hintText = 'Enter your password',
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.validators,
  });

  final String name;
  final String label;
  final String hintText;
  final TextInputAction textInputAction;
  final bool enabled;
  final List<FormFieldValidator<String>>? validators;

  @override
  Widget build(BuildContext context) {
    final obscurePassword = useState(true);

    return InputTextField(
      name: name,
      label: label,
      hintText: hintText,
      obscureText: obscurePassword.value,
      textInputAction: textInputAction,
      prefixIcon: Iconsax.lock,
      enabled: enabled,
      suffixIcon: IconButton(
        icon: Icon(
          obscurePassword.value ? Iconsax.eye : Iconsax.eye_slash,
          size: 20,
        ),
        onPressed: () {
          obscurePassword.value = !obscurePassword.value;
        },
      ),
      validators: validators,
    );
  }
}
