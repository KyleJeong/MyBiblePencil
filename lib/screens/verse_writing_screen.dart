import 'package:flutter/material.dart';
import '../models/bible_verse.dart';
import '../models/bible_translation.dart';
import '../services/bible_api_service.dart';
import '../services/verse_storage_service.dart';
import '../models/transcription.dart';
import '../services/database_service.dart';

class VerseWritingScreen extends StatefulWidget {
  final String book;
  final int chapter;
  final BibleTranslation translation;

  const VerseWritingScreen({
    super.key,
    required this.book,
    required this.chapter,
    required this.translation,
  });

  @override
  State<VerseWritingScreen> createState() => _VerseWritingScreenState();
}

class _VerseWritingScreenState extends State<VerseWritingScreen> {
  final BibleApiService _bibleApiService = BibleApiService();
  final VerseStorageService _storageService = VerseStorageService();
  List<BibleVerse>? _verses;
  bool _isLoading = true;
  String? _error;
  final TextEditingController _contentController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadVerses();
  }

  Future<void> _loadVerses() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final verses = await _bibleApiService.getVerses(
        widget.book,
        widget.chapter,
        widget.translation.id,
      );

      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTranscription() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필사 내용을 입력해주세요.')),
      );
      return;
    }

    try {
      final transcription = Transcription(
        language: widget.translation.language,
        translationId: widget.translation.id,
        book: widget.book,
        chapter: widget.chapter,
        content: _contentController.text,
        createdAt: DateTime.now(),
      );

      await _databaseService.insertTranscription(transcription);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필사가 저장되었습니다.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book} ${widget.chapter}장'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveTranscription,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _verses == null || _verses!.isEmpty
                  ? const Center(child: Text('구절을 찾을 수 없습니다.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _verses!.length,
                      itemBuilder: (context, index) {
                        final verse = _verses![index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 구절 번호
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  '${verse.verse}절',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              // 필사 영역
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: Stack(
                                  children: [
                                    // 원본 텍스트 (회색으로 표시)
                                    Text(
                                      verse.content,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 20,
                                        height: 1.5,
                                      ),
                                    ),
                                    // 필사 영역 (투명한 레이어)
                                    Positioned.fill(
                                      child: IgnorePointer(
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _contentController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  hintText: '여기에 필사하세요...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
} 