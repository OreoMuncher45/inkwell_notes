class NoteModel {
  final int? id;
  final String title;
  final String contentDelta;
  final String contentPlainText;
  final String? colorLabel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isArchived;

  NoteModel({
    this.id,
    required this.title,
    required this.contentDelta,
    required this.contentPlainText,
    this.colorLabel,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isArchived = false,
  });
}

class TagModel {
  final int? id;
  final String name;

  TagModel({this.id, required this.name});
}
