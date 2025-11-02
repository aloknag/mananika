# Project Blueprint: ADHD Notes

## Overview

ADHD Notes is a simple, intuitive note-taking application designed to help users capture and organize their thoughts with minimal friction. The app is built with Flutter and leverages the Gemini API to provide an intelligent "Ask Notes" feature, allowing users to ask questions about their own notes.

## Features

*   **Note Creation**: A simple editor for creating notes with a title and content.
*   **Note Listing**: A clean, scrollable list of all saved notes.
*   **Note Viewing**: A dedicated screen to view the full content of a note.
*   **Gemini-Powered Search**: An "Ask Notes" feature that uses the Gemini API to answer questions based on the content of the user's notes.
*   **Settings**: A screen for configuring the application, including the Gemini API key.
*   **Cross-Platform**: The app is designed to run on Android, iOS, and the web, with platform-specific UI considerations.

## Design and Style

*   **Theme**: The application uses a modern, Material Design-based theme with a simple and clean aesthetic.
*   **Layout**: The layout is designed to be intuitive and easy to navigate, with a focus on a clear and uncluttered user experience.
*   **Components**: The app uses a combination of standard Flutter widgets and Cupertino widgets for a native-like feel on Apple platforms.

## Project Structure

*   `lib/main.dart`: The main entry point of the application.
*   `lib/note_model.dart`: The data model for a single note.
*   `lib/note_editor_screen.dart`: The screen for creating and editing notes, and for accessing the "Ask Notes" feature.
*   `lib/notes_list_screen.dart`: The screen that displays a list of all notes.
*   `lib/note_detail_screen.dart`: The screen that displays the full content of a single note.
*   `lib/settings_screen.dart`: The screen for managing application settings.
*   `lib/settings_provider.dart`: A provider for managing and persisting application settings.

## Development Steps

1.  **Initial Setup**: Created a new Flutter project.
2.  **Dependencies**: Added the following dependencies:
    *   `hive` and `hive_flutter` for local data storage.
    *   `provider` for state management.
    *   `shared_preferences` for storing settings.
    *   `google_generative_ai` for the "Ask Notes" feature.
    *   `file_picker` for selecting a vault directory (on non-web platforms).
3.  **Note Model**: Created the `Note` data model and the necessary Hive type adapter.
4.  **Note Editor**: Built the `NoteEditorScreen` for creating notes, with fields for title and content.
5.  **Note List and Detail**: Created the `NotesListScreen` and `NoteDetailScreen` to display and view notes.
6.  **Settings**: Implemented the `SettingsScreen` to allow users to set their Gemini API key and select a vault path.
7.  **Gemini Integration**: Implemented the `_searchNotes` function to send a prompt to the Gemini API and display the response.
8.  **Error Handling and Bug Fixes**:
    *   Resolved numerous build and runtime errors related to dependencies, code generation, and constructor issues.
    *   Fixed a platform-specific issue with the `file_picker` package on the web.
    *   Addressed a layout overflow issue on Android when the keyboard is displayed.
    *   Fixed a copy-paste issue on macOS by using a `CupertinoTextField`.
    *   Added a `try-catch` block to the Gemini API call to prevent crashes from invalid API keys.
9.  **Blueprint Creation**: Created this `blueprint.md` file to document the project.
