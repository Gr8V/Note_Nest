import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _notesKey = 'notes_data';
  static const String _trashKey = 'trash_data';

  // ================================================================
  // NOTES STORAGE
  // ================================================================

  static Future<void> saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_notesKey);

    List<dynamic> notesList =
        existing != null ? jsonDecode(existing) : [];

    notesList.add(note.toJson());

    await prefs.setString(_notesKey, jsonEncode(notesList));
  }

  static Future<void> editNote(Note updatedNote) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);

    if (raw == null) return;

    List decoded = jsonDecode(raw);

    final index =
        decoded.indexWhere((note) => note["id"] == updatedNote.id);

    if (index == -1) return;

    decoded[index] = updatedNote.toJson();

    await prefs.setString(_notesKey, jsonEncode(decoded));
  }

  static Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);

    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Note.fromJson(e)).toList();
  }

  static Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);

    if (raw == null) return;

    List decoded = jsonDecode(raw);

    decoded.removeWhere((note) => note["id"] == noteId);

    await prefs.setString(_notesKey, jsonEncode(decoded));
  }

  // ================================================================
  // TRASH SYSTEM
  // ================================================================

  /// Move note from notes_data → trash_data
  static Future<void> moveNoteToTrash(Note note) async {
    final prefs = await SharedPreferences.getInstance();

    // Remove from notes
    final rawNotes = prefs.getString(_notesKey);
    List notesList = rawNotes != null ? jsonDecode(rawNotes) : [];
    notesList.removeWhere((n) => n["id"] == note.id);
    await prefs.setString(_notesKey, jsonEncode(notesList));

    // Add to trash
    final rawTrash = prefs.getString(_trashKey);
    List trashList = rawTrash != null ? jsonDecode(rawTrash) : [];
    trashList.add(note.toJson());
    await prefs.setString(_trashKey, jsonEncode(trashList));
  }

  /// Get all trashed notes
  static Future<List<Note>> getTrashedNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_trashKey);

    if (raw == null) return [];

    final List decoded = jsonDecode(raw);
    return decoded.map((e) => Note.fromJson(e)).toList();
  }

  /// Restore note from trash → notes_data
  static Future<void> restoreNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();

    final rawTrash = prefs.getString(_trashKey);
    if (rawTrash == null) return;

    List trashList = jsonDecode(rawTrash);

    // find note
    final index = trashList.indexWhere((n) => n["id"] == noteId);
    if (index == -1) return;

    final noteJson = trashList[index];

    // remove from trash
    trashList.removeAt(index);
    await prefs.setString(_trashKey, jsonEncode(trashList));

    // add back to notes
    final rawNotes = prefs.getString(_notesKey);
    List notesList = rawNotes != null ? jsonDecode(rawNotes) : [];
    notesList.add(noteJson);
    await prefs.setString(_notesKey, jsonEncode(notesList));
  }

  /// Permanently delete a note from trash
  static Future<void> deleteNoteFromTrash(String noteId) async {
    final prefs = await SharedPreferences.getInstance();

    final rawTrash = prefs.getString(_trashKey);
    if (rawTrash == null) return;

    List trashList = jsonDecode(rawTrash);
    trashList.removeWhere((n) => n["id"] == noteId);

    await prefs.setString(_trashKey, jsonEncode(trashList));
  }

  /// Empty the entire trash bin
  static Future<void> emptyTrash() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_trashKey); // delete trash_data completely
  }

  // ================================================================
  // THEME STORAGE
  // ================================================================

  static const String _themeModeKey = 'theme_mode';
  static const String _themeTypeKey = 'theme_type';

  static Future<ThemeMode?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeModeKey);
    if (themeString == null) return null;

    return ThemeMode.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => ThemeMode.system,
    );
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  static Future<AppThemeType?> getThemeType() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeTypeKey);
    if (themeString == null) return null;

    return AppThemeType.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => AppThemeType.defaultTheme,
    );
  }

  static Future<void> saveThemeType(AppThemeType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeTypeKey, type.toString());
  }
}
