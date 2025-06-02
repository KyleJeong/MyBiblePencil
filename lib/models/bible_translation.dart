class BibleTranslation {
  final String id;
  final String name;
  final String language;
  final String languageCode;

  const BibleTranslation({
    required this.id,
    required this.name,
    required this.language,
    required this.languageCode,
  });

  static const List<BibleTranslation> translations = [
    BibleTranslation(
      id: 'krv',
      name: '개역개정',
      language: '한국어',
      languageCode: 'ko',
    ),
    BibleTranslation(
      id: 'kjv',
      name: 'King James Version',
      language: 'English',
      languageCode: 'en',
    ),
    BibleTranslation(
      id: 'niv',
      name: 'New International Version',
      language: 'English',
      languageCode: 'en',
    ),
  ];

  static List<BibleTranslation> getTranslationsByLanguage(String languageCode) {
    return translations.where((t) => t.languageCode == languageCode).toList();
  }

  static List<String> getAvailableLanguages() {
    return translations.map((t) => t.language).toSet().toList();
  }
} 