import 'package:flutter/material.dart';
import '../services/bible_api_service.dart';
import '../models/bible_verse.dart';
import 'bible_write_detail_screen.dart';

class BibleWriteScreen extends StatefulWidget {
  const BibleWriteScreen({super.key});

  @override
  State<BibleWriteScreen> createState() => _BibleWriteScreenState();
}

class _BibleWriteScreenState extends State<BibleWriteScreen> {
  final BibleApiService _bibleApiService = BibleApiService();
  
  // 선택된 값들
  Map<String, dynamic>? _selectedLanguage;
  Map<String, dynamic>? _selectedVersion;
  Map<String, dynamic>? _selectedBook;
  int? _selectedChapter;
  
  // 데이터 목록들
  List<Map<String, dynamic>> _languages = [];
  List<Map<String, dynamic>> _versions = [];
  List<Map<String, dynamic>> _books = [];
  List<int> _chapters = [];
  List<BibleVerse> _verses = [];
  
  // 로딩 상태
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final languages = await _bibleApiService.getLanguages();
      setState(() {
        _languages = languages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '언어 목록을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadVersions(String languageCode) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final versions = await _bibleApiService.getVersions(languageCode);
      setState(() {
        _versions = versions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '번역본 목록을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBooks(String version) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final books = await _bibleApiService.getBooks(version);
      setState(() {
        _books = books;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '책 목록을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadVerses(String version, String book, int chapter) async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final verses = await _bibleApiService.getVerses(version, book, chapter);
      setState(() {
        _verses = verses;
        _isLoading = false;
      });

      // 장을 선택한 경우에만 필사 화면으로 이동
      if (verses.isNotEmpty && _selectedChapter != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BibleWriteDetailScreen(
              verses: verses,
              bookName: _selectedBook!['name'],
              chapter: chapter,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = '구절을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Widget _buildLanguageSelector() {
    if (_languages.isEmpty) {
      return const Text('사용 가능한 언어가 없습니다.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('언어 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Map<String, dynamic>>(
          value: _selectedLanguage,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintText: '언어를 선택하세요',
          ),
          items: _languages.map((language) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: language,
              child: Text(language['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value;
              _selectedVersion = null;
              _selectedBook = null;
              _selectedChapter = null;
              _versions = [];
              _books = [];
              _verses = [];
            });
            if (value != null) {
              _loadVersions(value['code']);
            }
          },
        ),
      ],
    );
  }

  Widget _buildVersionSelector() {
    if (_versions.isEmpty) {
      return const Text('사용 가능한 번역본이 없습니다.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('번역본 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<Map<String, dynamic>>(
          value: _selectedVersion,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            hintText: '번역본을 선택하세요',
          ),
          items: _versions.map((version) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: version,
              child: Text(version['name']),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedVersion = value;
              _selectedBook = null;
              _selectedChapter = null;
              _books = [];
              _verses = [];
            });
            if (value != null) {
              _loadBooks(value['code']);
            }
          },
        ),
      ],
    );
  }

  Widget _buildBookSelector() {
    if (_books.isEmpty) {
      return const Text('사용 가능한 책이 없습니다.');
    }

    // 구약과 신약으로 분류
    final oldTestament = _books.where((book) => int.parse(book['code']) <= 39).toList();
    final newTestament = _books.where((book) => int.parse(book['code']) > 39).toList();

    Widget buildBookButton(Map<String, dynamic> book) {
      return InkWell(
        onTap: () {
          setState(() {
            _selectedBook = book;
            _selectedChapter = null;
            _verses = [];
          });
          _loadVerses(_selectedVersion!['code'], book['code'], 1);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _selectedBook?['code'] == book['code'] ? Colors.blue[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _selectedBook?['code'] == book['code'] ? Colors.blue : Colors.grey,
            ),
          ),
          child: Text(
            book['name'],
            style: TextStyle(
              color: _selectedBook?['code'] == book['code'] ? Colors.blue : Colors.black,
              fontWeight: _selectedBook?['code'] == book['code'] ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('책 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // 구약성경 섹션
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: const Row(
                  children: [
                    Icon(Icons.book, size: 20),
                    SizedBox(width: 8),
                    Text('구약성경', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: oldTestament.map((book) => buildBookButton(book)).toList(),
                ),
              ),
              const Divider(height: 1),
              // 신약성경 섹션
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[200],
                child: const Row(
                  children: [
                    Icon(Icons.book, size: 20),
                    SizedBox(width: 8),
                    Text('신약성경', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: newTestament.map((book) => buildBookButton(book)).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChapterSelector() {
    if (_selectedBook == null) {
      return const SizedBox.shrink();
    }

    final maxChapter = _selectedBook!['maxChapter'] as int;
    final chapters = List.generate(maxChapter, (index) => index + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('장 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chapters.map((chapter) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedChapter = chapter;
                    });
                    _loadVerses(_selectedVersion!['code'], _selectedBook!['code'], chapter);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedChapter == chapter ? Colors.blue[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _selectedChapter == chapter ? Colors.blue : Colors.grey,
                      ),
                    ),
                    child: Text(
                      '$chapter장',
                      style: TextStyle(
                        color: _selectedChapter == chapter ? Colors.blue : Colors.black,
                        fontWeight: _selectedChapter == chapter ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyBiblePencil'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildLanguageSelector(),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _selectedLanguage != null
                            ? _buildVersionSelector()
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_selectedVersion != null) _buildBookSelector(),
                  const SizedBox(height: 16),
                  if (_selectedBook != null) _buildChapterSelector(),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
} 