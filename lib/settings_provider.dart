
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String? _vaultPath;
  String? _apiKey;

  String? get vaultPath => _vaultPath;
  String? get apiKey => _apiKey;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _vaultPath = prefs.getString('vaultPath');
    _apiKey = prefs.getString('apiKey');
    notifyListeners();
  }

  Future<void> setVaultPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('vaultPath', path);
    _vaultPath = path;
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiKey', key);
    _apiKey = key;
    notifyListeners();
  }
}
