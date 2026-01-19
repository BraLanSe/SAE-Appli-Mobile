import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bookwise.db');
    return await openDatabase(
      path,
      version: 2, // Bump version to force recreate/upgrade
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Simple migration: Drop and recreate (ok for dev/student project)
      // In production, we would use ALTER TABLE
      await db.execute('DROP TABLE IF EXISTS favorites');
      await db.execute('DROP TABLE IF EXISTS history');
      await _createTables(db);
    }
  }

  Future<void> _createTables(Database db) async {
    // Table pour les favoris
    await db.execute('''
      CREATE TABLE favorites(
        book_id TEXT PRIMARY KEY,
        title TEXT,
        genre TEXT,
        added_at INTEGER
      )
    ''');

    // Table pour l'historique
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        book_id TEXT,
        title TEXT,
        genre TEXT,
        read_at INTEGER,
        UNIQUE(book_id)
      )
    ''');
  }

  // --- Analysis ---

  /// Retourne les 3 genres les plus fréquents combinés (History + Favorites)
  Future<List<String>> getPreferredGenres() async {
    final db = await database;

    // On fait une UNION ALL pour combiner les deux tables
    // PUIS un GROUP BY et COUNT
    /*
      SELECT genre, COUNT(*) as count 
      FROM (
        SELECT genre FROM favorites
        UNION ALL
        SELECT genre FROM history
      ) 
      WHERE genre IS NOT NULL AND genre != ''
      GROUP BY genre 
      ORDER BY count DESC 
      LIMIT 3
    */

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT genre, COUNT(*) as count 
      FROM (
        SELECT genre FROM favorites
        UNION ALL
        SELECT genre FROM history
      ) 
      WHERE genre IS NOT NULL AND genre != ''
      GROUP BY genre 
      ORDER BY count DESC 
      LIMIT 3
    ''');

    return result.map((row) => row['genre'] as String).toList();
  }

  // --- Favoris ---

  Future<void> addFavorite(String bookId, String title, String genre) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'book_id': bookId,
        'title': title,
        'genre': genre, // Added
        'added_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String bookId) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'book_id = ?',
      whereArgs: [bookId],
    );
  }

  Future<List<String>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) => maps[i]['book_id'] as String);
  }

  // --- Historique ---

  Future<void> addToHistory(String bookId, String title, String genre) async {
    final db = await database;
    await db.insert(
      'history',
      {
        'book_id': bookId,
        'title': title,
        'genre': genre, // Added
        'read_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<String>> getHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'history',
      orderBy: 'read_at DESC', // Plus récents d'abord
    );
    return List.generate(maps.length, (i) => maps[i]['book_id'] as String);
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}
