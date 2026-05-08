import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:inkwell_notes/core/database/database.dart';
import 'package:inkwell_notes/core/database/notes_repository.dart';

void main() {
  late AppDatabase db;
  late NotesRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = NotesRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('can create and watch notes', () async {
    await repo.createNote(
      title: 'Test Note',
      contentDelta: '{}',
      contentPlainText: 'Hello world',
    );

    final notes = await repo.watchAllNotes().first;
    expect(notes.length, 1);
    expect(notes.first.title, 'Test Note');
  });
}
