# Inkwell Notes - Implementation Plan

## Journal
*   **2026-05-08**: Phase 2 completed: Drift database schema defined, repositories implemented with domain models, and Riverpod providers set up.
*   **2026-05-08**: Phase 3-5 completed: Notes list with NoteCard widget, Flutter Quill editor integration, full-text search, and tagging system implemented.
*   **2026-05-08**: Final polish: Absolute imports used, Quill 11.0 breaking changes addressed, and project structure refined.

## Phase 1: Project Scaffold & Theming
- [x] Create a Flutter package...
...
- [x] After committing the change, if the app is running, use the `hot_reload` tool to reload it.

## Phase 2: Database Schema & State Management
- [x] Add dependencies: `drift`, `sqlite3_flutter_libs`, `path_provider`, `path`.
- [x] Define schema in `tables.dart` and `database.dart`.
- [x] Generate code with `build_runner`.
- [x] Implement `NotesRepository` and `TagsRepository`.
- [x] Create Riverpod providers for database and repositories.

## Phase 3: Notes List & Basic Operations
- [x] Update `NotesListScreen` with `allNotesProvider`.
- [x] Create `NoteCard` widget.
- [x] Add FAB for creating notes.
- [x] Implement delete functionality.

## Phase 4: Rich Text Editor Integration (Flutter Quill)
- [x] Add `flutter_quill` dependency.
- [x] Implement `NoteEditorScreen` with `QuillController`.
- [x] Implement save/load logic for Delta JSON.

## Phase 5: Search & Tagging
- [x] Implement `SearchScreen` with full-text search.
- [x] Implement `TagsScreen` for tag management.
- [x] Add tagging UI to `NoteEditorScreen`.

## Phase 6: Final Polish & APK Build
- [x] Run `analyze_files` and fix issues.
- [ ] APK build (Environment restricted).
