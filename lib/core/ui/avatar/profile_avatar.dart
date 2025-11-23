import 'package:betaversion/core/ui/media/media_view.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final String heroTag;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.size = 48,
    this.heroTag = 'profile-avatar',
    this.onTap,
  });

  static const String defaultAvatarUrl =
      'https://assets.leetcode.com/users/avatars/avatar_1670096509.png';

  @override
  Widget build(BuildContext context) {
    final avatar = Hero(
      tag: heroTag,
      child: MediaView.universal(
        path: imageUrl ?? defaultAvatarUrl,
        width: size,
        height: size,
        isImageRound: true,
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}
