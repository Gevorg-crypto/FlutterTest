import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  static const String _boxName = 'settingsBox';
  static const String _key = 'isDarkMode';

  @observable
  ThemeMode themeMode = ThemeMode.light;

  @action
  Future<void> loadTheme() async {
    final box = await Hive.openBox(_boxName);
    final isDark = box.get(_key, defaultValue: false);
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @action
  Future<void> toggleTheme() async {
    final box = await Hive.openBox(_boxName);
    final isDark = themeMode == ThemeMode.dark;
    final newIsDark = !isDark;

    await box.put(_key, newIsDark);
    themeMode = newIsDark ? ThemeMode.dark : ThemeMode.light;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
}
