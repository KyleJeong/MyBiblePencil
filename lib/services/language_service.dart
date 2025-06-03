import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  late Locale _currentLocale;
  final SharedPreferences _prefs;

  LanguageService(this._prefs) {
    _loadSavedLanguage();
  }

  Locale get currentLocale => _currentLocale;

  void _loadSavedLanguage() {
    final savedLanguage = _prefs.getString(_languageKey);
    if (savedLanguage != null) {
      _currentLocale = Locale(savedLanguage);
    } else {
      // Use device locale as default
      _currentLocale = const Locale('ko');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLocale = Locale(languageCode);
    await _prefs.setString(_languageKey, languageCode);
    notifyListeners();
  }

  static Future<LanguageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return LanguageService(prefs);
  }
} 