import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Available theme colors
enum AppThemeColor {
  neutral,
  blue,
  green,
  purple,
  orange,
  pink,
  teal,
  red,
  indigo,
  amber,
}

extension AppThemeColorExtension on AppThemeColor {
  String get label {
    switch (this) {
      case AppThemeColor.neutral:
        return 'Neutral';
      case AppThemeColor.blue:
        return 'Blue';
      case AppThemeColor.green:
        return 'Green';
      case AppThemeColor.purple:
        return 'Purple';
      case AppThemeColor.orange:
        return 'Orange';
      case AppThemeColor.pink:
        return 'Pink';
      case AppThemeColor.teal:
        return 'Teal';
      case AppThemeColor.red:
        return 'Red';
      case AppThemeColor.indigo:
        return 'Indigo';
      case AppThemeColor.amber:
        return 'Amber';
    }
  }

  Color get color {
    switch (this) {
      case AppThemeColor.neutral:
        return const Color.fromARGB(255, 24, 24, 24);
      case AppThemeColor.blue:
        return const Color(0xFF2563EB);
      case AppThemeColor.green:
        return const Color(0xFF16A34A);
      case AppThemeColor.purple:
        return const Color(0xFF7C3AED);
      case AppThemeColor.orange:
        return const Color(0xFFEA580C);
      case AppThemeColor.pink:
        return const Color(0xFFDB2777);
      case AppThemeColor.teal:
        return const Color(0xFF0D9488);
      case AppThemeColor.red:
        return const Color(0xFFDC2626);
      case AppThemeColor.indigo:
        return const Color(0xFF4F46E5);
      case AppThemeColor.amber:
        return const Color(0xFFD97706);
    }
  }

  Color get lightVariant {
    switch (this) {
      case AppThemeColor.neutral:
        return const Color.fromARGB(255, 212, 211, 211);
      case AppThemeColor.blue:
        return const Color(0xFF3B82F6);
      case AppThemeColor.green:
        return const Color(0xFF22C55E);
      case AppThemeColor.purple:
        return const Color(0xFF8B5CF6);
      case AppThemeColor.orange:
        return const Color(0xFFF97316);
      case AppThemeColor.pink:
        return const Color(0xFFEC4899);
      case AppThemeColor.teal:
        return const Color(0xFF14B8A6);
      case AppThemeColor.red:
        return const Color(0xFFEF4444);
      case AppThemeColor.indigo:
        return const Color(0xFF6366F1);
      case AppThemeColor.amber:
        return const Color(0xFFF59E0B);
    }
  }
}

// Theme color repository for SharedPreferences operations
class ThemeColorRepository {
  static const String _colorKey = 'app_theme_color';

  Future<AppThemeColor> getThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_colorKey) ?? 0; // Default to neutral
    return AppThemeColor.values[colorIndex];
  }

  Future<void> setThemeColor(AppThemeColor color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.index);
  }
}

// Theme color repository provider
final themeColorRepositoryProvider = Provider<ThemeColorRepository>((ref) {
  return ThemeColorRepository();
});

// Theme color notifier to manage color state
class ThemeColorNotifier extends StateNotifier<AppThemeColor> {
  final ThemeColorRepository _repository;

  ThemeColorNotifier(this._repository) : super(AppThemeColor.neutral) {
    _loadColor();
  }

  Future<void> _loadColor() async {
    final color = await _repository.getThemeColor();
    state = color;
  }

  Future<void> setColor(AppThemeColor color) async {
    state = color;
    await _repository.setThemeColor(color);
  }
}

// Theme color provider
final themeColorProvider =
    StateNotifierProvider<ThemeColorNotifier, AppThemeColor>((ref) {
      final repository = ref.watch(themeColorRepositoryProvider);
      return ThemeColorNotifier(repository);
    });
