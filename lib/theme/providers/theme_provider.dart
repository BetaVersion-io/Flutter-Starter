import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme repository for SharedPreferences operations
class ThemeRepository {
  static const String _themeKey = 'app_theme_mode';

  Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to system
    return ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);
  }
}

// Theme repository provider
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepository();
});

// Theme notifier to manage theme state
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeRepository _repository;

  ThemeNotifier(this._repository) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeMode = await _repository.getThemeMode();
    state = themeMode;
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    state = themeMode;
    await _repository.setThemeMode(themeMode);
  }
}

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(themeRepositoryProvider);
  return ThemeNotifier(repository);
});
