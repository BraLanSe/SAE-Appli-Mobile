import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookwise.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // Table favoris
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        title TEXT,
        author TEXT,
        genre TEXT,
        imagePath TEXT,
        description TEXT,
        popularity INTEGER,
        dateAdded TEXT,
        clicks INTEGER,
        favorites INTEGER,
        minutesRead REAL
      )
    ''');

    // Table historique
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        title TEXT,
        author TEXT,
        genre TEXT,
        imagePath TEXT,
        description TEXT,
        popularity INTEGER,
        dateAdded TEXT,
        clicks INTEGER,
        favorites INTEGER,
        minutesRead REAL
      )
    ''');
  }

  // --- Favoris ---
  Future<void> addFavorite(Book book) async {
    final db = await database;
    await db.insert('favorites', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Book>> getFavorites() async {
    final db = await database;
    final maps = await db.query('favorites');
    return maps.map((map) => Book.fromMap(map)).toList();
  }

  // --- Historique ---
  Future<void> addToHistory(Book book) async {
    final db = await database;
    await db.insert('history', book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getHistory() async {
    final db = await database;
    final maps = await db.query('history', orderBy: 'dateAdded DESC');
    return maps.map((map) => Book.fromMap(map)).toList();
  }
  /// Mettre à jour le temps de lecture
  Future<void> updateMinutesRead(String id, double minutes) async {
    final db = await database;
    await db.update(
      'history',
      {'minutesRead': minutes},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
