import 'package:flutter/material.dart';
import '../models/transcription.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';
import 'verse_writing_screen.dart';
import '../models/bible_translation.dart';

class SavedTranscriptionsScreen extends StatefulWidget {
  const SavedTranscriptionsScreen({super.key});

  @override
  State<SavedTranscriptionsScreen> createState() => _SavedTranscriptionsScreenState();
}

class _SavedTranscriptionsScreenState extends State<SavedTranscriptionsScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Transcription> _transcriptions = [];
  bool _isLoading = true;
  String? _error;
  Transcription? _selectedTranscription;

  @override
  void initState() {
    super.initState();
    _loadTranscriptions();
  }

  Future<void> _loadTranscriptions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final transcriptions = await _databaseService.getTranscriptions();

      setState(() {
        _transcriptions = transcriptions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteTranscription(Transcription transcription) async {
    try {
      await _databaseService.deleteTranscription(transcription.id!);
      await _loadTranscriptions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('필사가 삭제되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  void _showDeleteConfirmation(Transcription transcription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('필사 삭제'),
        content: Text('${transcription.book} ${transcription.chapter}장의 필사를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTranscription(transcription);
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _navigateToWritingScreen(Transcription transcription) {
    // 번역본 정보 생성
    final translation = BibleTranslation(
      id: transcription.translationId,
      name: transcription.translationId, // 실제 이름은 필요에 따라 수정
      language: transcription.language,
      languageCode: transcription.language == '한국어' ? 'ko' : 'en',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerseWritingScreen(
          book: transcription.book,
          chapter: transcription.chapter,
          translation: translation,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('저장된 필사'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _transcriptions.isEmpty
                  ? const Center(child: Text('저장된 필사가 없습니다.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _transcriptions.length,
                      itemBuilder: (context, index) {
                        final transcription = _transcriptions[index];
                        final isSelected = _selectedTranscription?.id == transcription.id;
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTranscription = isSelected ? null : transcription;
                              });
                              if (!isSelected) {
                                _navigateToWritingScreen(transcription);
                              }
                            },
                            onLongPress: () {
                              _showDeleteConfirmation(transcription);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${transcription.book} ${transcription.chapter}장',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '언어: ${transcription.language}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '저장일: ${DateFormat('yyyy년 MM월 dd일 HH:mm').format(transcription.createdAt)}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    transcription.content,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
} 