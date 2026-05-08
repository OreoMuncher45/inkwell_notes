import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inkwell_notes/core/database/notes_repository.dart';
import 'package:inkwell_notes/features/notes/presentation/widgets/note_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchedNotesProvider(_query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Type to search'))
          : searchResults.when(
              data: (notes) {
                if (notes.isEmpty) {
                  return const Center(child: Text('No results found'));
                }
                return ListView.builder(
                  itemCount: notes.length,
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
    );
  }
}
