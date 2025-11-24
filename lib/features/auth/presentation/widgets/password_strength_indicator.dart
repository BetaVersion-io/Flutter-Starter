import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Password strength indicator widget
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({
    required this.password,
    super.key,
    this.showLabel = true,
  });

  final String password;
  final bool showLabel;

  PasswordStrength get _strength {
    if (password.isEmpty) return PasswordStrength.none;
    if (password.length < 6) return PasswordStrength.weak;

    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp('[A-Z]'))) score++;
    if (password.contains(RegExp('[a-z]'))) score++;
    if (password.contains(RegExp('[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score == 3) return PasswordStrength.medium;
    if (score == 4) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: _strength.color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _strength.progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _strength.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showLabel) ...[
          const Gap(8),
          Text(
            _strength.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: _strength.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

enum PasswordStrength { none, weak, medium, strong, veryStrong }

extension PasswordStrengthExtension on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.none:
        return '';
      case PasswordStrength.weak:
        return 'Weak password';
      case PasswordStrength.medium:
        return 'Medium password';
      case PasswordStrength.strong:
        return 'Strong password';
      case PasswordStrength.veryStrong:
        return 'Very strong password';
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.none:
        return Colors.grey;
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return Colors.green;
    }
  }

  double get progress {
    switch (this) {
      case PasswordStrength.none:
        return 0;
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1;
    }
  }
}
