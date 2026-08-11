import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/core/cache/app_cache.dart';
import 'package:task_management/src/logic/cubit/theme_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeCubit', () {
    late ThemeCubit cubit;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      await AppCache.initializeCache();
    });

    setUp(() async {
      await AppCache.instance.remove('app_theme_mode');
      cubit = ThemeCubit();
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state defaults to ThemeMode.dark', () {
      expect(cubit.state, equals(ThemeMode.dark));
    });

    test('setThemeMode updates state to light', () {
      cubit.setThemeMode(ThemeMode.light);
      expect(cubit.state, equals(ThemeMode.light));
    });

    test('toggleTheme switches between dark and light', () {
      expect(cubit.state, equals(ThemeMode.dark));
      cubit.toggleTheme();
      expect(cubit.state, equals(ThemeMode.light));
      cubit.toggleTheme();
      expect(cubit.state, equals(ThemeMode.dark));
    });
  });
}
