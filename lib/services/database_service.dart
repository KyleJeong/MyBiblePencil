import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transcription.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bible_transcriptions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transcriptions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        language TEXT NOT NULL,
        translation_id TEXT NOT NULL,
        book TEXT NOT NULL,
        chapter INTEGER NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTranscription(Transcription transcription) async {
    final db = await database;
    return await db.insert('transcriptions', transcription.toMap());
  }

  Future<List<Transcription>> getTranscriptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transcriptions',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Transcription.fromMap(maps[i]));
  }

  Future<List<Transcription>> getTranscriptionsByBook(String book) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transcriptions',
      where: 'book = ?',
      whereArgs: [book],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Transcription.fromMap(maps[i]));
  }

  Future<List<Transcription>> getTranscriptionsByChapter(String book, int chapter) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transcriptions',
      where: 'book = ? AND chapter = ?',
      whereArgs: [book, chapter],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Transcription.fromMap(maps[i]));
  }

  Future<void> deleteTranscription(int id) async {
    final db = await database;
    await db.delete(
      'transcriptions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 