import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/services/local_storage.dart';

class NotesProvider extends ChangeNotifier {
  // ================================
  // MAIN LISTS
  // ================================
  List<Note> _notes = [];
  List<Note> _trashNotes = [];

  List<Note> get notes => _notes;
  List<Note> get trashNotes => _trashNotes;

  // ================================
  // LOAD DATA AT STARTUP
  // ================================
  NotesProvider() {
    loadNotes();
    loadTrashNotes();
  }

  Future<void> loadNotes() async {
    _notes = await LocalStorageService.getNotes();
    notifyListeners();
  }

  Future<void> loadTrashNotes() async {
    _trashNotes = await LocalStorageService.getTrashedNotes();
    notifyListeners();
  }

  // ================================
  // NOTES CRUD
  // ================================
  Future<void> addNote(Note noteEntry) async {
    await LocalStorageService.saveNote(noteEntry);
    _notes.add(noteEntry);
    notifyListeners();
  }

  Future<void> updateNote(Note updatedNote) async {
    await LocalStorageService.editNote(updatedNote);

    final index = _notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  Future<void> deleteNoteById(String id) async {
    await LocalStorageService.deleteNote(id);
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  // ================================
  // TRASH SYSTEM
  // ================================

  /// Move note from main notes → trash
  Future<void> moveToTrash(Note note) async {
    await LocalStorageService.moveNoteToTrash(note);

    // Update in-memory lists
    _notes.removeWhere((n) => n.id == note.id);
    _trashNotes.add(note);

    notifyListeners();
  }

  /// Restore Note: trash → main notes
  Future<void> restoreNote(String id) async {
    await LocalStorageService.restoreNote(id);

    // Find the note inside trash list
    final index = _trashNotes.indexWhere((note) => note.id == id);
    if (index == -1) return;

    final restoredNote = _trashNotes[index];

    // Update local lists
    _trashNotes.removeAt(index);
    _notes.add(restoredNote);

    notifyListeners();
  }

  /// Permanently delete a single note from trash
  Future<void> deleteFromTrash(String id) async {
    await LocalStorageService.deleteNoteFromTrash(id);

    _trashNotes.removeWhere((note) => note.id == id);

    notifyListeners();
  }

  /// Empty the entire trash bin
  Future<void> emptyTrash() async {
    await LocalStorageService.emptyTrash();

    _trashNotes.clear();
    notifyListeners();
  }
}
