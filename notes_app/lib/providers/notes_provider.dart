import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_model.dart';
import 'package:notes_app/services/local_storage.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NotesProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _notes = await LocalStorageService.getNotes();
    notifyListeners();
  }

  Future<void> addNote(Note noteEntry) async {
    await LocalStorageService.saveNote(noteEntry); // <-- use your existing function

    _notes.add(noteEntry); // update local list
    notifyListeners();     // update UI
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

}
