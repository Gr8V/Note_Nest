import 'package:flutter/material.dart';
import 'package:notes_app/notes_model.dart';
import 'package:notes_app/local_storage.dart';

class NotesProvider extends ChangeNotifier {
  // ================================
  // MAIN LISTS
  // ================================

  //all notes
  List<Note> _notes = [];
  //notes in search list
  List<Note> _filteredNotes = [];
  //notes in trash bin
  List<Note> _trashNotes = [];

  List<Note> get notes => _notes;
  List<Note> get filteredNotes => _filteredNotes;
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
    _filteredNotes = _notes;
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

  void searchNotes(String query) {
    if (query.isEmpty) {
      _filteredNotes = _notes;
    } else {
      _filteredNotes = _notes
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // ================================
  // TRASH SYSTEM
  // ================================

  Future<void> moveToTrash(Note note) async {
    await LocalStorageService.moveNoteToTrash(note);

    // Update local lists
    _notes.removeWhere((n) => n.id == note.id);
    _trashNotes.add(note);

    notifyListeners();
  }

  Future<void> restoreNote(String id) async {
    await LocalStorageService.restoreNote(id);

    final index = _trashNotes.indexWhere((note) => note.id == id);
    if (index == -1) return;

    final restoredNote = _trashNotes[index];

    // Update local lists
    _trashNotes.removeAt(index);
    _notes.add(restoredNote);

    notifyListeners();
  }

  Future<void> deleteFromTrash(String id) async {
    await LocalStorageService.deleteNoteFromTrash(id);

    _trashNotes.removeWhere((note) => note.id == id);

    notifyListeners();
  }

  Future<void> emptyTrash() async {
    await LocalStorageService.emptyTrash();

    _trashNotes.clear();
    notifyListeners();
  }
}
