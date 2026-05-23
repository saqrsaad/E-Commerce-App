import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeService _themeService = ThemeService();
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _isDarkMode = await _themeService.isDarkMode();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _themeService.setThemeMode(_isDarkMode);
  }
}