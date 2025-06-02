class BibleBook {
  final String name;
  final String englishName;
  final int chapters;
  final String testament; // 'old' or 'new'

  const BibleBook({
    required this.name,
    required this.englishName,
    required this.chapters,
    required this.testament,
  });

  static const List<BibleBook> books = [
    // 구약
    BibleBook(name: '창세기', englishName: 'Genesis', chapters: 50, testament: 'old'),
    BibleBook(name: '출애굽기', englishName: 'Exodus', chapters: 40, testament: 'old'),
    BibleBook(name: '레위기', englishName: 'Leviticus', chapters: 27, testament: 'old'),
    BibleBook(name: '민수기', englishName: 'Numbers', chapters: 36, testament: 'old'),
    BibleBook(name: '신명기', englishName: 'Deuteronomy', chapters: 34, testament: 'old'),
    // ... 나머지 구약 성경
    // 신약
    BibleBook(name: '마태복음', englishName: 'Matthew', chapters: 28, testament: 'new'),
    BibleBook(name: '마가복음', englishName: 'Mark', chapters: 16, testament: 'new'),
    BibleBook(name: '누가복음', englishName: 'Luke', chapters: 24, testament: 'new'),
    BibleBook(name: '요한복음', englishName: 'John', chapters: 21, testament: 'new'),
    // ... 나머지 신약 성경
  ];
} 