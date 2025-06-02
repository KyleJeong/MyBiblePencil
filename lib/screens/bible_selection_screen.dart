import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_translation.dart';
import 'verse_writing_screen.dart';
import 'saved_transcriptions_screen.dart';

class BibleSelectionScreen extends StatefulWidget {
  const BibleSelectionScreen({super.key});

  @override
  State<BibleSelectionScreen> createState() => _BibleSelectionScreenState();
}

class _BibleSelectionScreenState extends State<BibleSelectionScreen> {
  String selectedLanguage = '한국어';
  BibleTranslation? selectedTranslation;
  String? selectedBook;
  static const String _lastLanguageKey = 'last_selected_language';
  static const String _lastTranslationKey = 'last_selected_translation';

  // 각 성경 책의 장 수를 정의
  static const Map<String, int> _chapterCounts = {
    '창세기': 50, '출애굽기': 40, '레위기': 27, '민수기': 36, '신명기': 34,
    '여호수아': 24, '사사기': 21, '룻기': 4, '사무엘상': 31, '사무엘하': 24,
    '열왕기상': 22, '열왕기하': 25, '역대상': 29, '역대하': 36, '에스라': 10,
    '느헤미야': 13, '에스더': 10, '욥기': 42, '시편': 150, '잠언': 31,
    '전도서': 12, '아가': 8, '이사야': 66, '예레미야': 52, '예레미야애가': 5,
    '에스겔': 48, '다니엘': 12, '호세아': 14, '요엘': 3, '아모스': 9,
    '오바댜': 1, '요나': 4, '미가': 7, '나훔': 3, '하박국': 3,
    '스바냐': 3, '학개': 2, '스가랴': 14, '말라기': 4,
    '마태복음': 28, '마가복음': 16, '누가복음': 24, '요한복음': 21, '사도행전': 28,
    '로마서': 16, '고린도전서': 16, '고린도후서': 13, '갈라디아서': 6, '에베소서': 6,
    '빌립보서': 4, '골로새서': 4, '데살로니가전서': 5, '데살로니가후서': 3, '디모데전서': 6,
    '디모데후서': 4, '디도서': 3, '빌레몬서': 1, '히브리서': 13, '야고보서': 5,
    '베드로전서': 5, '베드로후서': 3, '요한일서': 5, '요한이서': 1, '요한삼서': 1,
    '유다서': 1, '요한계시록': 22,
  };

  @override
  void initState() {
    super.initState();
    _loadLastSelection();
  }

  Future<void> _loadLastSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLanguage = prefs.getString(_lastLanguageKey) ?? '한국어';
    final lastTranslationId = prefs.getString(_lastTranslationKey);

    setState(() {
      selectedLanguage = lastLanguage;
      if (lastTranslationId != null) {
        selectedTranslation = BibleTranslation.translations.firstWhere(
          (t) => t.id == lastTranslationId,
          orElse: () => BibleTranslation.getTranslationsByLanguage(
              lastLanguage == '한국어' ? 'ko' : 'en').first,
        );
      } else {
        selectedTranslation = BibleTranslation.getTranslationsByLanguage(
            lastLanguage == '한국어' ? 'ko' : 'en').first;
      }
    });
  }

  Future<void> _saveSelection() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastLanguageKey, selectedLanguage);
    if (selectedTranslation != null) {
      await prefs.setString(_lastTranslationKey, selectedTranslation!.id);
    }
  }

  void _showChapterSelection(String book) {
    setState(() {
      selectedBook = book;
    });
  }

  void _navigateToVerseWriting(int chapter) {
    if (selectedTranslation != null && selectedBook != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerseWritingScreen(
            book: selectedBook!,
            chapter: chapter,
            translation: selectedTranslation!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('성경 선택'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedTranscriptionsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 언어 및 번역본 선택
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 언어 선택 드롭다운
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: '언어',
                      border: OutlineInputBorder(),
                    ),
                    items: BibleTranslation.getAvailableLanguages()
                        .map((language) => DropdownMenuItem(
                              value: language,
                              child: Text(language),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedLanguage = value;
                          // 언어가 변경되면 해당 언어의 첫 번째 번역본 선택
                          selectedTranslation = BibleTranslation
                              .getTranslationsByLanguage(
                                  value == '한국어' ? 'ko' : 'en')
                              .first;
                        });
                        _saveSelection();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // 번역본 선택 드롭다운
                Expanded(
                  child: DropdownButtonFormField<BibleTranslation>(
                    value: selectedTranslation,
                    decoration: const InputDecoration(
                      labelText: '번역본',
                      border: OutlineInputBorder(),
                    ),
                    items: BibleTranslation.getTranslationsByLanguage(
                            selectedLanguage == '한국어' ? 'ko' : 'en')
                        .map((translation) => DropdownMenuItem(
                              value: translation,
                              child: Text(translation.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedTranslation = value;
                        });
                        _saveSelection();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          // 성경 책 선택 또는 장 선택
          Expanded(
            child: selectedBook == null
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildBookSection(context, '구약성경', [
                        '창세기', '출애굽기', '레위기', '민수기', '신명기',
                        '여호수아', '사사기', '룻기', '사무엘상', '사무엘하',
                        '열왕기상', '열왕기하', '역대상', '역대하', '에스라',
                        '느헤미야', '에스더', '욥기', '시편', '잠언',
                        '전도서', '아가', '이사야', '예레미야', '예레미야애가',
                        '에스겔', '다니엘', '호세아', '요엘', '아모스',
                        '오바댜', '요나', '미가', '나훔', '하박국',
                        '스바냐', '학개', '스가랴', '말라기',
                      ]),
                      const Divider(),
                      _buildBookSection(context, '신약성경', [
                        '마태복음', '마가복음', '누가복음', '요한복음', '사도행전',
                        '로마서', '고린도전서', '고린도후서', '갈라디아서', '에베소서',
                        '빌립보서', '골로새서', '데살로니가전서', '데살로니가후서', '디모데전서',
                        '디모데후서', '디도서', '빌레몬서', '히브리서', '야고보서',
                        '베드로전서', '베드로후서', '요한일서', '요한이서', '요한삼서',
                        '유다서', '요한계시록',
                      ]),
                    ],
                  )
                : _buildChapterSelection(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSection(BuildContext context, String title, List<String> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: books.map((book) {
            return ElevatedButton(
              onPressed: () => _showChapterSelection(book),
              child: Text(book),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChapterSelection() {
    final chapterCount = _chapterCounts[selectedBook] ?? 0;
    return Column(
      children: [
        // 선택된 책 표시 및 뒤로가기 버튼
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedBook = null;
                  });
                },
              ),
              Expanded(
                child: Text(
                  selectedBook!,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        // 장 선택 그리드
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // 한 줄에 8개씩 표시
              childAspectRatio: 1,
              crossAxisSpacing: 4, // 간격 줄임
              mainAxisSpacing: 4, // 간격 줄임
            ),
            itemCount: chapterCount,
            itemBuilder: (context, index) {
              final chapter = index + 1;
              return InkWell(
                onTap: () => _navigateToVerseWriting(chapter),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      chapter.toString(),
                      style: TextStyle(
                        fontSize: 14, // 글자 크기 줄임
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 