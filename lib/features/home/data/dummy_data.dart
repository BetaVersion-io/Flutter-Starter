import 'package:betaversion/features/home/domain/entities/category.dart';
import 'package:betaversion/features/home/domain/entities/post.dart';
import 'package:betaversion/features/home/domain/entities/quick_action.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Dummy data for home screen - Replace with API calls later
class HomeDummyData {
  static const List<Category> categories = [
    Category(
      id: '1',
      name: 'Technology',
      icon: Iconsax.cpu,
      color: Color(0xFF6366F1),
    ),
    Category(
      id: '2',
      name: 'Design',
      icon: Iconsax.brush_1,
      color: Color(0xFFEC4899),
    ),
    Category(
      id: '3',
      name: 'Business',
      icon: Iconsax.briefcase,
      color: Color(0xFF10B981),
    ),
    Category(
      id: '4',
      name: 'Marketing',
      icon: Iconsax.chart,
      color: Color(0xFFF59E0B),
    ),
    Category(
      id: '5',
      name: 'Finance',
      icon: Iconsax.dollar_circle,
      color: Color(0xFF3B82F6),
    ),
  ];

  static const List<QuickAction> quickActions = [
    QuickAction(
      id: '1',
      label: 'New Post',
      icon: Iconsax.add_circle,
      color: Color(0xFF6366F1),
    ),
    QuickAction(
      id: '2',
      label: 'Messages',
      icon: Iconsax.message,
      color: Color(0xFF10B981),
    ),
    QuickAction(
      id: '3',
      label: 'Bookmarks',
      icon: Iconsax.bookmark,
      color: Color(0xFFF59E0B),
    ),
    QuickAction(
      id: '4',
      label: 'Analytics',
      icon: Iconsax.diagram,
      color: Color(0xFFEC4899),
    ),
  ];

  static List<Post> get posts => [
        Post(
          id: 1,
          title: 'Getting Started with Flutter',
          body:
              'Flutter is an open-source UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.',
          author: 'John Doe',
          authorAvatar: 'https://i.pravatar.cc/150?img=1',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          likes: 128,
          comments: 24,
          imageUrl: 'https://picsum.photos/seed/flutter/400/200',
          tags: ['Flutter', 'Mobile', 'Development'],
        ),
        Post(
          id: 2,
          title: 'Clean Architecture in Flutter',
          body:
              'Learn how to structure your Flutter applications using clean architecture principles for better maintainability and testability.',
          author: 'Jane Smith',
          authorAvatar: 'https://i.pravatar.cc/150?img=2',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          likes: 256,
          comments: 42,
          tags: ['Architecture', 'Best Practices'],
        ),
        Post(
          id: 3,
          title: 'State Management with Riverpod',
          body:
              'Riverpod is a reactive caching and data-binding framework that was born as an evolution of the Provider package.',
          author: 'Mike Johnson',
          authorAvatar: 'https://i.pravatar.cc/150?img=3',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          likes: 89,
          comments: 15,
          imageUrl: 'https://picsum.photos/seed/riverpod/400/200',
          tags: ['Riverpod', 'State Management'],
        ),
        Post(
          id: 4,
          title: 'Building Beautiful UIs',
          body:
              'Tips and tricks for creating stunning user interfaces in Flutter with custom widgets and animations.',
          author: 'Sarah Wilson',
          authorAvatar: 'https://i.pravatar.cc/150?img=4',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          likes: 312,
          comments: 58,
          tags: ['UI', 'Design', 'Widgets'],
        ),
        Post(
          id: 5,
          title: 'API Integration Patterns',
          body:
              'Explore different patterns for integrating REST APIs in your Flutter applications with proper error handling.',
          author: 'Alex Brown',
          authorAvatar: 'https://i.pravatar.cc/150?img=5',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          likes: 178,
          comments: 31,
          imageUrl: 'https://picsum.photos/seed/api/400/200',
          tags: ['API', 'Networking'],
        ),
      ];

  static const String userName = 'Satyam';
  static const String userAvatar = 'https://i.pravatar.cc/150?img=8';
  static const int unreadNotifications = 3;
}
