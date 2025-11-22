//thememode value notifier
import 'package:flutter/material.dart';
import 'package:notes_app/services/local_storage.dart';

ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> loadSavedTheme() async {
  final savedTheme = await LocalStorageService.getThemeMode();
  themeNotifier.value = savedTheme ?? ThemeMode.system;
}

/// Set and save theme
Future<void> setTheme(ThemeMode mode) async {
  themeNotifier.value = mode;
  await LocalStorageService.saveThemeMode(mode);
}