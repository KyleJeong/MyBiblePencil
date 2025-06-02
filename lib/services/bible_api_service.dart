import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_verse.dart';

class BibleApiService {
  static const String _baseUrl = 'https://bible-api.com';

  // Map translation IDs to bible-api.com format
  static const Map<String, String> _translationMap = {
    'kr': 'krv',    // Korean Revised Version
    'en': 'kjv',    // King James Version
    'niv': 'niv',   // New International Version
    'krv': 'krv',   // Korean Revised Version (alternative ID)
  };

  // Map book names to common names used by bible-api.com
  static const Map<String, String> _bookMap = {
    '창세기': 'Genesis',
    '출애굽기': 'Exodus',
    '레위기': 'Leviticus',
    '민수기': 'Numbers',
    '신명기': 'Deuteronomy',
    '여호수아': 'Joshua',
    '사사기': 'Judges',
    '룻기': 'Ruth',
    '사무엘상': '1 Samuel',
    '사무엘하': '2 Samuel',
    '열왕기상': '1 Kings',
    '열왕기하': '2 Kings',
    '역대상': '1 Chronicles',
    '역대하': '2 Chronicles',
    '에스라': 'Ezra',
    '느헤미야': 'Nehemiah',
    '에스더': 'Esther',
    '욥기': 'Job',
    '시편': 'Psalms',
    '잠언': 'Proverbs',
    '전도서': 'Ecclesiastes',
    '아가': 'Song of Solomon',
    '이사야': 'Isaiah',
    '예레미야': 'Jeremiah',
    '예레미야애가': 'Lamentations',
    '에스겔': 'Ezekiel',
    '다니엘': 'Daniel',
    '호세아': 'Hosea',
    '요엘': 'Joel',
    '아모스': 'Amos',
    '오바댜': 'Obadiah',
    '요나': 'Jonah',
    '미가': 'Micah',
    '나훔': 'Nahum',
    '하박국': 'Habakkuk',
    '스바냐': 'Zephaniah',
    '학개': 'Haggai',
    '스가랴': 'Zechariah',
    '말라기': 'Malachi',
    '마태복음': 'Matthew',
    '마가복음': 'Mark',
    '누가복음': 'Luke',
    '요한복음': 'John',
    '사도행전': 'Acts',
    '로마서': 'Romans',
    '고린도전서': '1 Corinthians',
    '고린도후서': '2 Corinthians',
    '갈라디아서': 'Galatians',
    '에베소서': 'Ephesians',
    '빌립보서': 'Philippians',
    '골로새서': 'Colossians',
    '데살로니가전서': '1 Thessalonians',
    '데살로니가후서': '2 Thessalonians',
    '디모데전서': '1 Timothy',
    '디모데후서': '2 Timothy',
    '디도서': 'Titus',
    '빌레몬서': 'Philemon',
    '히브리서': 'Hebrews',
    '야고보서': 'James',
    '베드로전서': '1 Peter',
    '베드로후서': '2 Peter',
    '요한일서': '1 John',
    '요한이서': '2 John',
    '요한삼서': '3 John',
    '유다서': 'Jude',
    '요한계시록': 'Revelation',
  };

  Future<List<BibleVerse>> getVerses(String book, int chapter, String translation) async {
    try {
      final bookName = _bookMap[book] ?? book;
      final url = '$_baseUrl/$bookName%20$chapter?translation=$translation';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final verses = data['verses'] as List;
        
        return verses.map((verse) => BibleVerse(
          book: book,
          chapter: chapter,
          verse: verse['verse'].toString(),
          content: verse['text'],
        )).toList();
      } else {
        throw Exception('Failed to load verses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load verses: $e');
    }
  }
} 