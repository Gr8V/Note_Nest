import 'package:flutter/material.dart';
import 'package:notes_app/local_storage.dart';
import 'app_theme.dart';

// Theme notifiers
ValueNotifier<AppThemeType> themeTypeNotifier = ValueNotifier(AppThemeType.defaultTheme);
ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

/// Load saved theme settings
Future<void> loadSavedTheme() async {
  final savedMode = await LocalStorageService.getThemeMode();
  final savedType = await LocalStorageService.getThemeType();
  
  themeModeNotifier.value = savedMode ?? ThemeMode.system;
  themeTypeNotifier.value = savedType ?? AppThemeType.defaultTheme;
}

/// Set and save theme mode 
Future<void> setThemeMode(ThemeMode mode) async {
  themeModeNotifier.value = mode;
  await LocalStorageService.saveThemeMode(mode);
}

/// Set and save theme type (color theme)
Future<void> setThemeType(AppThemeType type) async {
  themeTypeNotifier.value = type;
  await LocalStorageService.saveThemeType(type);
}