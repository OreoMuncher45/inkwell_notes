import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/notes/presentation/notes_list_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/tags/presentation/tags_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorNotesKey = GlobalKey<NavigatorState>(debugLabel: 'notes');
final _shellNavigatorSearchKey = GlobalKey<NavigatorState>(
  debugLabel: 'search',
);
final _shellNavigatorTagsKey = GlobalKey<NavigatorState>(debugLabel: 'tags');
final _shellNavigatorSettingsKey = GlobalKey<NavigatorState>(
  debugLabel: 'settings',
);

final appRouter = GoRouter(
  initialLocation: '/notes',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorNotesKey,
          routes: [
            GoRoute(
              path: '/notes',
              builder: (context, state) => const NotesListScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSearchKey,
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTagsKey,
          routes: [
            GoRoute(
              path: '/tags',
              builder: (context, state) => const TagsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
