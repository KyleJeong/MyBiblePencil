import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bible_verse.dart';

class BibleApiService {
  static const String _baseUrl = 'https://ebcdev2.cafe24.com/mybible/api';

  // API 엔드포인트
  static const String _languagesEndpoint = '/languages';
  static const String _versionsEndpoint = '/versions';
  static const String _booksEndpoint = '/books';
  static const String _versesEndpoint = '/verses';

  // 지원되는 언어 목록 가져오기
  Future<List<String>> getLanguages() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$_languagesEndpoint'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((lang) => lang.toString()).toList();
      } else {
        throw Exception('Failed to load languages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load languages: $e');
    }
  }

  // 특정 언어의 성경 버전 목록 가져오기
  Future<List<Map<String, dynamic>>> getVersions(String language) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_versionsEndpoint?language=$language')
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((version) => version as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load versions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load versions: $e');
    }
  }

  // 특정 버전의 책 목록 가져오기
  Future<List<Map<String, dynamic>>> getBooks(String version) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_booksEndpoint?version=$version')
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((book) => book as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }

  // 특정 책의 특정 장의 구절 가져오기
  Future<List<BibleVerse>> getVerses(String version, String book, int chapter) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_versesEndpoint?version=$version&book=$book&chapter=$chapter')
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((verse) => BibleVerse(
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