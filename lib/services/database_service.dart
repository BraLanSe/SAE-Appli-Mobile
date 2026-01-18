import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../data/data.dart'; // Import pour récupérer les livres initiaux

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookwise_v2.db'); // Nouveau nom pour forcer la recréation propre
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 2,
        onCreate: _createDB,
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await _ensureSchema(db);
          }
        },
      );
  }

  Future _createDB(Database db, int version) async {
    // 1. Table Catalogue (Tous les livres)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS books (
        id TEXT PRIMARY KEY,
        title TEXT,
        author TEXT,
        genre TEXT,
        imagePath TEXT,
        description TEXT,
        durationMinutes INTEGER,
        popularity INTEGER,
        dateAdded TEXT
      )
    ''');

    // 2. Table Interactions (Ce que l'utilisateur fait)
    // Note: On sépare les interactions du livre pour ne pas modifier le catalogue
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_stats (
        bookId TEXT PRIMARY KEY,
        isFavorite INTEGER DEFAULT 0,
        clicks INTEGER DEFAULT 0,
        minutesRead REAL DEFAULT 0.0,
        lastInteraction TEXT
      )
    ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS history (
          bookId TEXT PRIMARY KEY,
          visitedAt TEXT
        )
      '''
      );
    // 3. Remplissage automatique (Seed)
    await _populateBooks(db);
  }

  // Fonction pour injecter les données de data.dart dans SQL
  Future<void> _populateBooks(Database db) async {
    Batch batch = db.batch();
    for (var book in allBooks) {
      batch.insert(
        'books',
        {
          'id': book.id,
          'title': book.title,
          'author': book.author,
          'genre': book.genre,
          'imagePath': book.imagePath,
          'description': book.description,
          'durationMinutes': book.durationMinutes,
          'popularity': book.popularity,
          'dateAdded': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
    print("✅ Base de données BookWise remplie avec ${allBooks.length} livres.");
  }

    Future<void> _ensureSchema(Database db) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS books (
          id TEXT PRIMARY KEY,
          title TEXT,
          author TEXT,
          genre TEXT,
          imagePath TEXT,
          description TEXT,
          durationMinutes INTEGER,
          popularity INTEGER,
          dateAdded TEXT
        )
      '''
      );
      await db.execute('''
        CREATE TABLE IF NOT EXISTS user_stats (
          bookId TEXT PRIMARY KEY,
          isFavorite INTEGER DEFAULT 0,
          clicks INTEGER DEFAULT 0,
          minutesRead REAL DEFAULT 0.0,
          lastInteraction TEXT
        )
      '''
      );
      await db.execute('''
        CREATE TABLE IF NOT EXISTS history (
          bookId TEXT PRIMARY KEY,
          visitedAt TEXT
        )
      '''
      );
    }
  // --- MÉTHODES D'ACCÈS ---

  // Récupérer tous les livres (avec les stats utilisateur fusionnées)
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    
    // Jointure entre le catalogue (books) et les stats (user_stats)
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        b.*, 
        COALESCE(u.isFavorite, 0) as favorites,
        COALESCE(u.clicks, 0) as clicks,
        COALESCE(u.minutesRead, 0) as minutesRead
      FROM books b
      LEFT JOIN user_stats u ON b.id = u.bookId
    ''');

    return result.map((map) => Book.fromMap(map)).toList();
  }

  // Mettre à jour les stats (Coup de coeur, lecture, clics)
  Future<void> updateUserStat(String bookId, {bool? isFavorite, int? addClicks, double? addTime}) async {
    final db = await database;
    
    // Vérifier si une entrée existe déjà
    var result = await db.query('user_stats', where: 'bookId = ?', whereArgs: [bookId]);
    
    Map<String, dynamic> newData = {};
    
    if (result.isEmpty) {
      // Création
      newData = {
        'bookId': bookId,
        'isFavorite': (isFavorite == true) ? 1 : 0,
        'clicks': (addClicks ?? 0),
        'minutesRead': (addTime ?? 0.0),
        'lastInteraction': DateTime.now().toIso8601String()
      };
      await db.insert('user_stats', newData);
    } else {
      // Mise à jour
      var current = result.first;
      final currentClicks = (current['clicks'] as int?) ?? 0;
      final currentMinutes = (current['minutesRead'] as num?)?.toDouble() ?? 0.0;
      newData = {
        'lastInteraction': DateTime.now().toIso8601String()
      };
      if (isFavorite != null) newData['isFavorite'] = isFavorite ? 1 : 0;
      if (addClicks != null) newData['clicks'] = currentClicks + addClicks;
      if (addTime != null) newData['minutesRead'] = currentMinutes + addTime;

      await db.update('user_stats', newData, where: 'bookId = ?', whereArgs: [bookId]);
    }
  }

  // Récupérer les favoris uniquement
  Future<List<Book>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        b.*, 
        COALESCE(u.isFavorite, 0) as favorites,
        COALESCE(u.clicks, 0) as clicks,
        COALESCE(u.minutesRead, 0) as minutesRead
      FROM books b
      INNER JOIN user_stats u ON b.id = u.bookId
      WHERE u.isFavorite = 1
    ''');

    return result.map((map) => Book.fromMap(map)).toList();
  }

  Future<void> setFavorite(String bookId, bool isFavorite) async {
    await updateUserStat(bookId, isFavorite: isFavorite);
  }

  Future<void> clearFavorites() async {
    final db = await database;
    await db.update('user_stats', {'isFavorite': 0});
  }

  Future<List<Book>> getHistoryBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT
        b.*, 
        COALESCE(u.isFavorite, 0) as favorites,
        COALESCE(u.clicks, 0) as clicks,
        COALESCE(u.minutesRead, 0) as minutesRead
      FROM history h
      INNER JOIN books b ON b.id = h.bookId
      LEFT JOIN user_stats u ON b.id = u.bookId
      ORDER BY h.visitedAt DESC
    ''');

    return result.map((map) => Book.fromMap(map)).toList();
  }

  Future<void> addToHistory(String bookId) async {
    final db = await database;
    await db.insert(
      'history',
      {
        'bookId': bookId,
        'visitedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMinutesRead(String bookId, double minutesRead) async {
    final db = await database;
    final result = await db.query('user_stats', where: 'bookId = ?', whereArgs: [bookId]);
    if (result.isEmpty) {
      await db.insert('user_stats', {
        'bookId': bookId,
        'isFavorite': 0,
        'clicks': 0,
        'minutesRead': minutesRead,
        'lastInteraction': DateTime.now().toIso8601String(),
      });
    } else {
      await db.update(
        'user_stats',
        {
          'minutesRead': minutesRead,
          'lastInteraction': DateTime.now().toIso8601String(),
        },
        where: 'bookId = ?',
        whereArgs: [bookId],
      );
    }
  }

}