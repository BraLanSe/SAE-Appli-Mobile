import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Book> _favorites = [];
  final DatabaseService _db = DatabaseService();

  List<Book> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // Charge les favoris depuis la BDD au démarrage
    _favorites = await _db.getFavorites();
    notifyListeners();
  }

  bool isFavorite(String bookId) {
    return _favorites.any((book) => book.id == bookId);
  }

  Future<void> toggleFavorite(Book book) async {
    final isFav = isFavorite(book.id);
    if (isFav) {
      _favorites.removeWhere((b) => b.id == book.id);
      // Met à jour la BDD (isFavorite = 0)
      await _db.updateUserStat(book.id, isFavorite: false);
    } else {
      _favorites.add(book);
      // Met à jour la BDD (isFavorite = 1)
      await _db.updateUserStat(book.id, isFavorite: true);
    }
    notifyListeners();
  }
  
  Future<void> clearFavorites() async {
      // Logique pour vider si nécessaire
      _favorites.clear();
      // Appel BDD pour tout remettre à 0 (si implémenté dans ton service)
      notifyListeners();
  }
}