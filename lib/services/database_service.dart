import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../models/review.dart';

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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    // Table favoris
    await db.execute('''
      CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        genre TEXT,
        imagePath TEXT,
        description TEXT,
        popularity INTEGER,
        dateAdded TEXT,
        clicks INTEGER DEFAULT 0,
        favorites INTEGER DEFAULT 0,
        minutesRead REAL DEFAULT 0
      )
    ''');

    // Table historique
    await db.execute('''
      CREATE TABLE history (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        genre TEXT,
        imagePath TEXT,
        description TEXT,
        popularity INTEGER,
        dateAdded TEXT,
        clicks INTEGER DEFAULT 0,
        favorites INTEGER DEFAULT 0,
        minutesRead REAL DEFAULT 0
      )
    ''');

    // Table reviews
    await db.execute('''
      CREATE TABLE reviews (
        bookId TEXT PRIMARY KEY,
        rating REAL NOT NULL,
        pacing TEXT NOT NULL,
        likedEnding INTEGER NOT NULL,
        comment TEXT,
        date TEXT NOT NULL
      )
    ''');

    // Créer les index pour optimiser les performances
    await _createIndexes(db);
  }

  /// Méthode de migration pour passer de v1 à v2
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Ajouter les index sur la base existante
      await _createIndexes(db);
    }
  }

  /// Créer les index pour optimiser les requêtes
  Future _createIndexes(Database db) async {
    // Index pour optimiser le tri de l'historique par date (DESC pour ORDER BY DESC)
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_history_date ON history(dateAdded DESC)'
    );

    // Index pour optimiser la récupération des favoris par date
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_favorites_date ON favorites(dateAdded)'
    );

    // Index pour filtrer les reviews par note
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating)'
    );
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

  // --- Reviews ---
  Future<int> saveReview(Review review) async {
    final db = await database;
    return await db.insert('reviews', review.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Review?> getReview(String bookId) async {
    final db = await database;
    final maps = await db.query('reviews', where: 'bookId = ?', whereArgs: [bookId]);
    if (maps.isNotEmpty) {
      return Review.fromMap(maps.first);
    }
    return null;
  }

  /// Récupérer tous les avis
  Future<List<Review>> getAllReviews() async {
    final db = await database;
    final maps = await db.query('reviews', orderBy: 'date DESC');
    return maps.map((map) => Review.fromMap(map)).toList();
  }

  /// Récupérer les avis avec une note minimale
  Future<List<Review>> getReviewsByRating(double minRating) async {
    final db = await database;
    final maps = await db.query(
      'reviews',
      where: 'rating >= ?',
      whereArgs: [minRating],
      orderBy: 'rating DESC',
    );
    return maps.map((map) => Review.fromMap(map)).toList();
  }

  // --- Méthodes utilitaires ---
  
  /// Vérifier si un livre est dans les favoris
  Future<bool> isFavorite(String bookId) async {
    final db = await database;
    final result = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Vérifier si un livre est dans l'historique
  Future<bool> isInHistory(String bookId) async {
    final db = await database;
    final result = await db.query(
      'history',
      where: 'id = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Obtenir le nombre total de favoris
  Future<int> getFavoritesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM favorites');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Obtenir le nombre total d'avis
  Future<int> getReviewsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM reviews');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
