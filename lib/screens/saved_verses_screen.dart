import 'package:flutter/material.dart';
import '../models/bible_verse.dart';
import '../services/verse_storage_service.dart';

class SavedVersesScreen extends StatefulWidget {
  const SavedVersesScreen({super.key});

  @override
  State<SavedVersesScreen> createState() => _SavedVersesScreenState();
}

class _SavedVersesScreenState extends State<SavedVersesScreen> {
  final VerseStorageService _storageService = VerseStorageService();
  List<BibleVerse> _savedVerses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSavedVerses();
  }

  Future<void> _loadSavedVerses() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final verses = await _storageService.getSavedVerses();
      setState(() {
        _savedVerses = verses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = '저장된 구절을 불러오는데 실패했습니다: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteVerse(BibleVerse verse) async {
    try {
      await _storageService.deleteVerse(verse);
      await _loadSavedVerses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${verse.reference}이(가) 삭제되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제에 실패했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('저장된 구절'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _savedVerses.isEmpty
                  ? const Center(
                      child: Text('저장된 구절이 없습니다.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _savedVerses.length,
                      itemBuilder: (context, index) {
                        final verse = _savedVerses[index];
                        return Dismissible(
                          key: Key(verse.reference),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => _deleteVerse(verse),
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    verse.reference,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    verse.content,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (verse.savedAt != null) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      '저장일: ${verse.savedAt!.toString().split('.')[0]}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
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