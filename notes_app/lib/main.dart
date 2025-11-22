import 'package:flutter/material.dart';
import 'package:notes_app/pages/main/homepage.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:notes_app/theme/app_theme.dart';
import 'package:notes_app/theme/theme_controller.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider())
      ],
      child: const NotesApp(),
    )
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'NotesApp',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      }
    );
  }
}