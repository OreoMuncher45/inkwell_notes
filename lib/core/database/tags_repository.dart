import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:inkwell_notes/core/database/database.dart';
import 'package:inkwell_notes/core/database/database_provider.dart';
import 'package:inkwell_notes/core/models/note_model.dart';

part 'tags_repository.g.dart';

extension TagToModel on Tag {
  TagModel toModel() => TagModel(id: id, name: name);
}

class TagsRepository {
  final AppDatabase _db;

  TagsRepository(this._db);

  Stream<List<TagModel>> watchAllTags() {
    return _db.select(_db.tags).watch().map((tags) => tags.map((t) => t.toModel()).toList());
  }

  Future<int> createTag(String name) {
    return _db.into(_db.tags).insert(TagsCompanion.insert(name: name));
  }

  Future<void> deleteTag(int id) {
    return (_db.delete(_db.tags)..where((t) => t.id.equals(id))).go();
  }

  Future<void> addTagToNote(int noteId, int tagId) {
    return _db.into(_db.noteTags).insert(NoteTagsCompanion.insert(noteId: noteId, tagId: tagId));
  }

  Future<void> removeTagFromNote(int noteId, int tagId) {
    return (_db.delete(_db.noteTags)
          ..where((t) => t.noteId.equals(noteId) & t.tagId.equals(tagId)))
        .go();
  }

  Stream<List<TagModel>> watchTagsForNote(int noteId) {
    final query = _db.select(_db.tags).join([
      innerJoin(_db.noteTags, _db.noteTags.tagId.equalsExp(_db.tags.id)),
    ])
      ..where(_db.noteTags.noteId.equals(noteId));

    return query.watch().map((rows) => rows.map((row) => row.readTable(_db.tags).toModel()).toList());
  }
}

@riverpod
TagsRepository tagsRepository(ref) {
  return TagsRepository(ref.watch(databaseProvider));
}

@riverpod
Stream<List<TagModel>> allTags(ref) {
  return ref.watch(tagsRepositoryProvider).watchAllTags();
}

@riverpod
Stream<List<TagModel>> tagsForNote(ref, int noteId) {
  return ref.watch(tagsRepositoryProvider).watchTagsForNote(noteId);
}
