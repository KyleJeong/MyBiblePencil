class BibleVerse {
  final String book;
  final int chapter;
  final String verse;
  final String content;
  final DateTime? savedAt;

  BibleVerse({
    required this.book,
    required this.chapter,
    required this.verse,
    required this.content,
    this.savedAt,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      book: json['book'] as String,
      chapter: json['chapter'] as int,
      verse: json['verse'] as String,
      content: json['content'] as String,
      savedAt: json['savedAt'] != null 
          ? DateTime.parse(json['savedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'content': content,
      'savedAt': savedAt?.toIso8601String(),
    };
  }

  String get reference => '$book $chapter:$verse';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BibleVerse &&
          runtimeType == other.runtimeType &&
          book == other.book &&
          chapter == other.chapter &&
          verse == other.verse;

  @override
  int get hashCode => book.hashCode ^ chapter.hashCode ^ verse.hashCode;
} 