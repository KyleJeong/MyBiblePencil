import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bible_book.dart';
import '../models/bible_verse.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  final TextEditingController _writingController = TextEditingController();
  BibleBook? _selectedBook;
  int? _selectedChapter;
  List<BibleVerse> _verses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        _selectedBook = args['book'] as BibleBook;
        _selectedChapter = args['chapter'] as int;
        _loadVerses();
      }
    });
  }

  Future<void> _loadVerses() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: 실제 API 호출로 대체
    await Future.delayed(const Duration(seconds: 1));
    _verses = List.generate(
      10,
      (index) => BibleVerse(
        book: _selectedBook!.name,
        chapter: _selectedChapter!,
        verse: (index + 1).toString(),
        content: '이것은 ${_selectedBook!.name} ${_selectedChapter}장 ${index + 1}절의 내용입니다.',
      ),
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _writingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_selectedBook?.name ?? ""} ${_selectedChapter ?? ""}장'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // TODO: 저장 기능 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('저장되었습니다.')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // 성경 구절 표시
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: _verses.length,
                      itemBuilder: (context, index) {
                        final verse = _verses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${verse.verse}절',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(verse.content),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // 필사 영역
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _writingController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: const InputDecoration(
                              hintText: '여기에 필사하세요...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                _writingController.clear();
                              },
                              icon: const Icon(Icons.clear),
                              label: const Text('지우기'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: 복사 기능 구현
                              },
                              icon: const Icon(Icons.copy),
                              label: const Text('복사'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
} 