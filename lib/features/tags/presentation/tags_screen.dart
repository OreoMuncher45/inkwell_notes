import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inkwell_notes/core/database/tags_repository.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(allTagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
      ),
      body: tagsAsync.when(
        data: (tags) {
          if (tags.isEmpty) {
            return const Center(child: Text('No tags yet'));
          }
          return ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, index) {
              final tag = tags[index];
              return ListTile(
                leading: const Icon(Icons.label_outline),
                title: Text(tag.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    if (tag.id != null) {
                      ref.read(tagsRepositoryProvider).deleteTag(tag.id!);
                    }
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTagDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tag name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(tagsRepositoryProvider).createTag(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
