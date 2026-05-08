# Inkwell Notes - Implementation Plan

## Journal
*   **2026-05-08**: Project scaffolded, git initialized, base dependencies added (go_router, riverpod, google_fonts).
*   **2026-05-08**: Phase 1 completed: Theme system (Lora/Inter), GoRouter with StatefulShellRoute, and placeholder screens implemented.

## Phase 1: Project Scaffold & Theming
- [x] Create a Flutter package in the `/data/data/com.termux/files/home/inkwell_notes` directory.
- [x] Remove any boilerplate in the new package that will be replaced, including the test dir, if any.
- [x] Update the description of the package in the `pubspec.yaml` and set the version number to `0.1.0`.
- [x] Update the `README.md` to include a short placeholder description of the package.
- [x] Create the `CHANGELOG.md` to have the initial version of `0.1.0`.
- [x] Commit this empty version of the package to the current branch (`feature/inkwell-notes-scaffold`).
- [x] After committing the change, start running the app with the `launch_app` tool on the user's preferred device.
- [x] Add base dependencies: `go_router`, `flutter_riverpod`, `riverpod_annotation`, `google_fonts`.
- [x] Set up the theme system (Dark/Light mode) using `GoogleFonts` (`Lora` and `Inter`) and the specified color palettes.
- [x] Configure `go_router` with a `StatefulShellRoute` for the bottom navigation bar.
- [x] Create placeholder screens for Notes, Search, Tags, and Settings.
- [x] Implement the Empty State UI for the Notes List screen.
- [x] Run the `dart_fix` tool to clean up the code.
- [x] Run the `analyze_files` tool one more time and fix any issues.
- [x] Run any tests to make sure they all pass.
- [x] Run `dart_format` to make sure that the formatting is correct.
- [x] Re-read the `IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [x] Update the `IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After committing the change, if the app is running, use the `hot_reload` tool to reload it.

## Phase 2: Database Schema & State Management
... (rest of phases)
