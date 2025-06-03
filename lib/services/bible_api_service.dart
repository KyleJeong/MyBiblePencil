import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_verse.dart';

class BibleApiService {
  static const String _baseUrl = 'https://ebcdev2.cafe24.com/mybible/api';

  // API 엔드포인트
  static const String _languagesEndpoint = '/languages.php';
  static const String _versionsEndpoint = '/versions.php';
  static const String _booksEndpoint = '/books.php';
  static const String _versesEndpoint = '/verses.php';

  // 지원되는 언어 목록 가져오기
  Future<List<Map<String, dynamic>>> getLanguages() async {
    try {
      print('Requesting languages from: $_baseUrl$_languagesEndpoint');
      final response = await http.post(
        Uri.parse('$_baseUrl$_languagesEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({}),
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['languages'] != null) {
          final List<dynamic> languages = data['languages'];
          return languages.map((lang) => {
            'code': lang['code'],
            'name': lang['names']['ko'] ?? lang['names']['en'],
          }).toList();
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load languages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getLanguages: $e');
      throw Exception('Failed to load languages: $e');
    }
  }

  // 특정 언어의 성경 버전 목록 가져오기
  Future<List<Map<String, dynamic>>> getVersions(String language) async {
    try {
      final requestBody = {'language': language};
      print('Requesting versions with body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl$_versionsEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print('Versions response status: ${response.statusCode}');
      print('Versions response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Parsed versions data: $data');
        
        if (data['success'] == true && data['versions'] != null) {
          final List<dynamic> versions = data['versions'];
          print('Versions list: $versions');
          
          final mappedVersions = versions.map((version) => {
            'code': version['version_id'],
            'name': version['name'],
          }).toList();
          print('Mapped versions: $mappedVersions');
          
          return mappedVersions;
        } else {
          print('Invalid versions response format: success=${data['success']}, versions=${data['versions']}');
          throw Exception('Invalid versions response format');
        }
      } else {
        throw Exception('Failed to load versions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getVersions: $e');
      throw Exception('Failed to load versions: $e');
    }
  }

  // 특정 버전의 책 목록 가져오기
  Future<List<Map<String, dynamic>>> getBooks(String version) async {
    try {
      final requestBody = {'version_id': version};
      print('Requesting books with body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl$_booksEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print('Books response status: ${response.statusCode}');
      print('Books response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Parsed books data: $data');
        
        if (data['success'] == true && data['books'] != null) {
          final List<dynamic> books = data['books'];
          print('Books list: $books');
          
          final mappedBooks = books.map((book) => {
            'code': book['book_number'],
            'name': book['book_name'],
            'maxChapter': int.parse(book['max_chapters']),
          }).toList();
          print('Mapped books: $mappedBooks');
          
          return mappedBooks;
        } else {
          print('Invalid books response format: success=${data['success']}, books=${data['books']}');
          throw Exception('Invalid books response format');
        }
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getBooks: $e');
      throw Exception('Failed to load books: $e');
    }
  }

  // 특정 책의 특정 장의 구절 가져오기
  Future<List<BibleVerse>> getVerses(String version, String book, int chapter) async {
    try {
      print('Requesting verses for version: $version, book: $book, chapter: $chapter');
      final requestBody = {
        'version_id': version,
        'book_number': book,
        'chapter': chapter,
      };
      print('Request body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse('$_baseUrl$_versesEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );
      print('Verses response status: ${response.statusCode}');
      print('Verses response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Parsed response data: $data');
        
        if (data['success'] == true && data['verses'] != null) {
          final List<dynamic> verses = data['verses'];
          print('Number of verses received: ${verses.length}');
          print('First verse: ${verses.first}');
          
          final mappedVerses = verses.map((verse) {
            final bibleVerse = BibleVerse(
              book: book,
              chapter: chapter,
              verse: verse['verse_number'].toString(),
              content: verse['text'],
            );
            print('Mapped verse: ${bibleVerse.verse} - ${bibleVerse.content}');
            return bibleVerse;
          }).toList();
          
          print('Total mapped verses: ${mappedVerses.length}');
          return mappedVerses;
        } else {
          print('Invalid response format: success=${data['success']}, verses=${data['verses']}');
          throw Exception('Invalid verses response format');
        }
      } else {
        throw Exception('Failed to load verses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getVerses: $e');
      throw Exception('Failed to load verses: $e');
    }
  }
} 