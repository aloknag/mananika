
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _apiKeyController.text = Provider.of<SettingsProvider>(context, listen: false).apiKey ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vault Path', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(settings.vaultPath ?? 'Not selected'),
              const SizedBox(height: 16),
              if (kIsWeb)
                const Text('Vault selection is not available on the web.')
              else
                ElevatedButton(
                  onPressed: () async {
                    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
                    if (selectedDirectory != null) {
                      settings.setVaultPath(selectedDirectory);
                    }
                  },
                  child: const Text('Select Vault'),
                ),
              const SizedBox(height: 32),
              const Text('Gemini API Key', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: _apiKeyController,
                placeholder: 'Enter your Gemini API Key',
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16.0),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  settings.setApiKey(_apiKeyController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('API Key Saved!')),
                  );
                },
                child: const Text('Save API Key'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
