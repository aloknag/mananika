
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/note_model.dart';
import 'package:myapp/notes_list_screen.dart';
import 'package:myapp/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/settings_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADHD Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showAskNotesDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotesListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final note = Note(
            title: _titleController.text,
            content: _contentController.text,
            timestamp: DateTime.now(),
          );
          final box = Hive.box<Note>('notes');
          box.add(note);
          _titleController.clear();
          _contentController.clear();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  void _showAskNotesDialog(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final apiKey = settings.apiKey;

    if (apiKey == null || apiKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Gemini API Key in settings.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final questionController = TextEditingController();
        return AlertDialog(
          title: const Text('Ask Notes'),
          content: TextField(
            controller: questionController,
            decoration: const InputDecoration(
              hintText: 'Ask a question about your notes...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final answer = await _searchNotes(questionController.text, apiKey);
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Answer'),
                    content: SingleChildScrollView(child: Text(answer)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Ask'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _searchNotes(String question, String apiKey) async {
    try {
      final box = Hive.box<Note>('notes');
      final allNotes = box.values
          .map((note) => 'Title: ${note.title}\nContent: ${note.content}')
          .join('\n\n');

      final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
      final prompt =
          'Based on the following notes, please answer the question: "$question"\n\nNotes:\n$allNotes';
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      return response.text ?? 'I could not find an answer in your notes.';
    } catch (e) {
      // It's helpful to print the error for debugging purposes.
      print('Gemini API Error: $e');
      return 'An error occurred while communicating with the Gemini API. Please check that you have entered a valid API key and have a stable internet connection. Details: $e';
    }
  }
}
