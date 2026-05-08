import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inkwell_notes/core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                }
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('0.1.0'),
          ),
        ],
      ),
    );
  }
}
