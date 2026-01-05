

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isarcrud/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  // intialize database
  static late Isar isar;

  // create a note and save to db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path);
  }
  // list of notes
  final List<Note> currentNotes = [];

  // create note from db
  Future<void> addNote(String text) async {
    // create a new note
    final newNote = Note()..text = text;

    // save to db
    await isar.writeTxn(()=> isar.notes.put(newNote));

    // re read form db
    fetchNotes();
  }

  // read notes from db
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
    notifyListeners();
  }

  // update a note in db
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(()=> isar.notes.put(existingNote));
      await  fetchNotes();
    }
  }

  // delete a note
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(()=> isar.notes.delete(id)); 
    await fetchNotes();
  }
}