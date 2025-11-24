class Post {
  final int id;
  final String title;
  final String body;
  final String author;
  final String authorAvatar;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final String? imageUrl;
  final List<String> tags;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.author,
    required this.authorAvatar,
    required this.createdAt,
    required this.likes,
    required this.comments,
    this.imageUrl,
    this.tags = const [],
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
