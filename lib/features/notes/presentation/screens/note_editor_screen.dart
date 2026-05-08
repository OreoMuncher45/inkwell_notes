import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:inkwell_notes/core/database/notes_repository.dart';
import 'package:inkwell_notes/core/database/tags_repository.dart';
import 'package:inkwell_notes/core/models/note_model.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final int? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late QuillController _controller;
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = true;
  NoteModel? _initialNote;

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    if (widget.noteId != null) {
      final note = await ref.read(notesRepositoryProvider).getNoteById(widget.noteId!);
      if (note != null) {
        _initialNote = note;
        _titleController.text = note.title;
        final doc = Document.fromJson(jsonDecode(note.contentDelta));
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        _initEmpty();
      }
    } else {
      _initEmpty();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _initEmpty() {
    _controller = QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text;
    final contentDelta = jsonEncode(_controller.document.toDelta().toJson());
    final contentPlainText = _controller.document.toPlainText();

    if (title.isEmpty && contentPlainText.trim().isEmpty) {
      return;
    }

    if (_initialNote != null) {
      final updatedNote = _initialNote!.copyWith(
        title: title,
        contentDelta: contentDelta,
        contentPlainText: contentPlainText,
      );
      await ref.read(notesRepositoryProvider).updateNote(updatedNote);
    } else {
      await ref.read(notesRepositoryProvider).createNote(
            title: title,
            contentDelta: contentDelta,
            contentPlainText: contentPlainText,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tagsAsync = widget.noteId != null ? ref.watch(tagsForNoteProvider(widget.noteId!)) : const AsyncValue.data(<TagModel>[]);

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) await _saveNote();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontFamily: 'Lora',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.label_outline),
              onPressed: widget.noteId == null ? null : () => _showTagPicker(context),
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                await _saveNote();
                if (mounted) context.pop();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (widget.noteId != null)
              tagsAsync.when(
                data: (tags) => tags.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: tags.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(tags[index].name, style: const TextStyle(fontSize: 12)),
                              onDeleted: () {
                                ref.read(tagsRepositoryProvider).removeTagFromNote(widget.noteId!, tags[index].id!);
                              },
                            ),
                          ),
                        ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            QuillSimpleToolbar(
              controller: _controller,
              config: const QuillSimpleToolbarConfig(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: QuillEditor.basic(
                  controller: _controller,
                  config: const QuillEditorConfig(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTagPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final allTagsAsync = ref.watch(allTagsProvider);
          final noteTagsAsync = ref.watch(tagsForNoteProvider(widget.noteId!));

          return allTagsAsync.when(
            data: (allTags) => noteTagsAsync.when(
              data: (noteTags) {
                final noteTagIds = noteTags.map((t) => t.id).toSet();
                return ListView.builder(
                  itemCount: allTags.length,
                  itemBuilder: (context, index) {
                    final tag = allTags[index];
                    final isSelected = noteTagIds.contains(tag.id);
                    return ListTile(
                      title: Text(tag.name),
                      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                      onTap: () {
                        if (isSelected) {
                          ref.read(tagsRepositoryProvider).removeTagFromNote(widget.noteId!, tag.id!);
                        } else {
                          ref.read(tagsRepositoryProvider).addTagToNote(widget.noteId!, tag.id!);
                        }
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) => Center(child: Text('Error: $err')),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, __) => Center(child: Text('Error: $err')),
          );
        },
      ),
    );
  }
}

extension on NoteModel {
  NoteModel copyWith({
    String? title,
    String? contentDelta,
    String? contentPlainText,
  }) {
    return NoteModel(
      id: id,
      title: title ?? this.title,
      contentDelta: contentDelta ?? this.contentDelta,
      contentPlainText: contentPlainText ?? this.contentPlainText,
      colorLabel: colorLabel,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPinned: isPinned,
      isArchived: isArchived,
    );
  }
}
