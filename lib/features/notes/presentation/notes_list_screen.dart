import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inkwell_notes/core/database/notes_repository.dart';
import 'widgets/note_card.dart';

class NotesListScreen extends ConsumerWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(allNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inkwell', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_note, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Start writing...',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notes.length,
            padding: const EdgeInsets.only(bottom: 80),
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onTap: () => context.push('/editor/${note.id}'),
                onDelete: () {
                  if (note.id != null) {
                    ref.read(notesRepositoryProvider).deleteNote(note.id!);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/editor'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
