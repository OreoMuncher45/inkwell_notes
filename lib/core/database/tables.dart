import 'package:drift/drift.dart';

class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 0, max: 255)();
  TextColumn get contentDelta => text()();
  TextColumn get contentPlainText => text()();
  TextColumn get colorLabel => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
}

class NoteTags extends Table {
  IntColumn get noteId => integer().references(Notes, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {noteId, tagId};
}
