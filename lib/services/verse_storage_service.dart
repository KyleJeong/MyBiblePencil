import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_verse.dart';

class VerseStorageService {
  static const String _storageKey = 'saved_verses';

  Future<void> saveVerse(BibleVerse verse) async {
    final prefs = await SharedPreferences.getInstance();
    final savedVerses = await getSavedVerses();
    
    // 이미 저장된 구절인지 확인
    if (!savedVerses.any((v) => 
        v.book == verse.book && 
        v.chapter == verse.chapter && 
        v.verse == verse.verse)) {
      savedVerses.add(verse);
      await prefs.setString(_storageKey, jsonEncode(
        savedVerses.map((v) => v.toJson()).toList(),
      ));
    }
  }

  Future<List<BibleVerse>> getSavedVerses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? versesJson = prefs.getString(_storageKey);
    
    if (versesJson == null) {
      return [];
    }

    final List<dynamic> versesList = jsonDecode(versesJson);
    return versesList.map((json) => BibleVerse.fromJson(json)).toList();
  }

  Future<void> deleteVerse(BibleVerse verse) async {
    final prefs = await SharedPreferences.getInstance();
    final savedVerses = await getSavedVerses();
    
    savedVerses.removeWhere((v) => 
        v.book == verse.book && 
        v.chapter == verse.chapter && 
        v.verse == verse.verse);
    
    await prefs.setString(_storageKey, jsonEncode(
      savedVerses.map((v) => v.toJson()).toList(),
    ));
  }
} 