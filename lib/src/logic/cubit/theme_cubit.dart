import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/core/cache/app_cache.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeCacheKey = 'app_theme_mode';

  ThemeCubit() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    try {
      final savedTheme = AppCache.instance.getString(_themeCacheKey);
      if (savedTheme == 'light') return ThemeMode.light;
      if (savedTheme == 'dark') return ThemeMode.dark;
    } catch (_) {}
    return ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    AppCache.instance.setString(
      _themeCacheKey,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
    emit(mode);
  }

  void toggleTheme() {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(nextMode);
  }
}
