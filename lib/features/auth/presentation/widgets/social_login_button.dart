import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Social login button (Google, Facebook, Apple, etc.)
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({
    required this.provider,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: theme.colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            )
          else ...[
            Icon(
              provider.icon,
              size: 24,
              color: provider.color,
            ),
            const Gap(12),
            Text(
              'Continue with ${provider.name}',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Social provider enum
enum SocialProvider {
  google,
  facebook,
  apple,
}

extension SocialProviderExtension on SocialProvider {
  String get name {
    switch (this) {
      case SocialProvider.google:
        return 'Google';
      case SocialProvider.facebook:
        return 'Facebook';
      case SocialProvider.apple:
        return 'Apple';
    }
  }

  IconData get icon {
    switch (this) {
      case SocialProvider.google:
        return Icons.g_mobiledata;
      case SocialProvider.facebook:
        return Icons.facebook;
      case SocialProvider.apple:
        return Icons.apple;
    }
  }

  Color get color {
    switch (this) {
      case SocialProvider.google:
        return const Color(0xFFDB4437);
      case SocialProvider.facebook:
        return const Color(0xFF1877F2);
      case SocialProvider.apple:
        return Colors.black;
    }
  }
}
