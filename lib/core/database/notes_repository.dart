import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:inkwell_notes/core/database/database.dart';
import 'package:inkwell_notes/core/database/database_provider.dart';
import 'package:inkwell_notes/core/models/note_model.dart';

part 'notes_repository.g.dart';

extension NoteToModel on Note {
  NoteModel toModel() => NoteModel(
        id: id,
        title: title,
        contentDelta: contentDelta,
        contentPlainText: contentPlainText,
        colorLabel: colorLabel,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isPinned: isPinned,
        isArchived: isArchived,
      );
}

class NotesRepository {
  final AppDatabase _db;

  NotesRepository(this._db);

  Stream<List<NoteModel>> watchAllNotes() {
    return (_db.select(_db.notes)
          ..orderBy([
            (t) => OrderingTerm(expression: t.isPinned, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((notes) => notes.map((n) => n.toModel()).toList());
  }

  Future<int> createNote({
    required String title,
    required String contentDelta,
    required String contentPlainText,
  }) {
    return _db.into(_db.notes).insert(
          NotesCompanion.insert(
            title: title,
            contentDelta: contentDelta,
            contentPlainText: contentPlainText,
            updatedAt: Value(DateTime.now()),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> updateNote(NoteModel note) {
    if (note.id == null) return Future.value();
    return _db.update(_db.notes).replace(
          Note(
            id: note.id!,
            title: note.title,
            contentDelta: note.contentDelta,
            contentPlainText: note.contentPlainText,
            colorLabel: note.colorLabel,
            createdAt: note.createdAt,
            updatedAt: DateTime.now(),
            isPinned: note.isPinned,
            isArchived: note.isArchived,
          ),
        );
  }

  Future<void> deleteNote(int id) {
    return (_db.delete(_db.notes)..where((t) => t.id.equals(id))).go();
  }

  Future<NoteModel?> getNoteById(int id) {
    return (_db.select(_db.notes)..where((t) => t.id.equals(id)))
        .getSingleOrNull()
        .then((note) => note?.toModel());
  }

  Stream<List<NoteModel>> searchNotes(String query) {
    return (_db.select(_db.notes)
          ..where((t) =>
              t.title.contains(query) | t.contentPlainText.contains(query)))
        .watch()
        .map((notes) => notes.map((n) => n.toModel()).toList());
  }
}

@riverpod
NotesRepository notesRepository(ref) {
  return NotesRepository(ref.watch(databaseProvider));
}

@riverpod
Stream<List<NoteModel>> allNotes(ref) {
  return ref.watch(notesRepositoryProvider).watchAllNotes();
}

@riverpod
Stream<List<NoteModel>> searchedNotes(ref, String query) {
  if (query.isEmpty) return Stream.value([]);
  return ref.watch(notesRepositoryProvider).searchNotes(query);
}
