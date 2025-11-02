
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/note_model.dart';
import 'package:myapp/note_editor_screen.dart';
import 'package:myapp/settings_provider.dart'; // Import the new provider
import 'package:provider/provider.dart'; // Import provider

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADHD Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NoteEditorScreen(),
    );
  }
}
