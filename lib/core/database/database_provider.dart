import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:inkwell_notes/core/database/database.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
