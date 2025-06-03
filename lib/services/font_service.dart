import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

class FontService extends ChangeNotifier {
  static const String _fontFamilyKey = 'font_family';
  static const String _fontSizeKey = 'font_size';
  
  final SharedPreferences _prefs;
  late String _fontFamily;
  late double _fontSize;

  FontService(this._prefs) {
    _loadSavedSettings();
  }

  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;

  void _loadSavedSettings() {
    _fontFamily = _prefs.getString(_fontFamilyKey) ?? _getDefaultFont();
    _fontSize = _prefs.getDouble(_fontSizeKey) ?? 16.0;
  }

  String _getDefaultFont() {
    if (Platform.isIOS) {
      return 'SF Pro';
    } else {
      return 'Roboto';
    }
  }

  Future<void> setFontFamily(String fontFamily) async {
    _fontFamily = fontFamily;
    await _prefs.setString(_fontFamilyKey, fontFamily);
    notifyListeners();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _prefs.setDouble(_fontSizeKey, size);
    notifyListeners();
  }

  static Future<FontService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return FontService(prefs);
  }

  // Available font families that work well for both Korean and English
  static List<String> get availableFonts {
    if (Platform.isIOS) {
      return [
        'SF Pro',              // Apple's system font, supports both Korean and English
        'SF Pro Text',         // Apple's system font for text
        'SF Pro Display',      // Apple's system font for display
        'Apple SD Gothic Neo', // Apple's Korean font
        'Helvetica Neue',      // Classic font that works well with Korean
      ];
    } else {
      return [
        'Roboto',             // Google's system font, supports both Korean and English
        'Noto Sans',          // Google's font family that supports many languages
        'Noto Sans KR',       // Google's Korean font
        'Noto Serif',         // Google's serif font that supports many languages
        'Noto Serif KR',      // Google's Korean serif font
      ];
    }
  }

  // Font size presets
  static const Map<String, double> fontSizePresets = {
    'small': 14.0,
    'medium': 16.0,
    'large': 18.0,
    'extraLarge': 20.0,
  };
} 