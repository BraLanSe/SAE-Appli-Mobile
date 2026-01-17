import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Book> _favorites = [];
  final db = DatabaseService();

  List<Book> get favorites => _favorites;

  /// Charger les favoris depuis SQLite
  Future<void> loadFavorites() async {
    _favorites = await db.getFavorites();
    notifyListeners();
  }

  /// Ajouter un favori
  Future<void> addFavorite(Book book) async {
    // Augmenter le compteur favorites
    book.favorites += 1;
    await db.addFavorite(book);
    await loadFavorites();
  }

  /// Retirer un favori
  Future<void> removeFavorite(String id) async {
    await db.removeFavorite(id);
    await loadFavorites();
  }

  /// Ajouter ou retirer un favori (toggle)
  Future<void> toggleFavorite(Book book) async {
    if (isFavorite(book.id)) {
      await removeFavorite(book.id);
      book.favorites = (book.favorites - 1).clamp(0, 999999);
    } else {
      await addFavorite(book);
    }
  }

  /// Savoir si un livre est en favori
  bool isFavorite(String id) {
    return _favorites.any((book) => book.id == id);
  }
}
