class Transcription {
  final int? id;
  final String language;
  final String translationId;
  final String book;
  final int chapter;
  final String content;
  final DateTime createdAt;

  Transcription({
    this.id,
    required this.language,
    required this.translationId,
    required this.book,
    required this.chapter,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language': language,
      'translation_id': translationId,
      'book': book,
      'chapter': chapter,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Transcription.fromMap(Map<String, dynamic> map) {
    return Transcription(
      id: map['id'] as int,
      language: map['language'] as String,
      translationId: map['translation_id'] as String,
      book: map['book'] as String,
      chapter: map['chapter'] as int,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
} 