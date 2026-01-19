import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Book> _favorites = [];

  List<Book> get favorites => _favorites;

  /// Charger les favoris depuis SQLite
  Future<void> loadFavorites(List<Book> allBooks) async {
    final dbService = DatabaseService();
    List<String> validIds = await dbService.getFavorites();

    // On filtre les livres dont l'ID est dans la base
    _favorites = allBooks.where((book) => validIds.contains(book.id)).toList();

    // Mettre à jour le compteur favorites
    for (var book in allBooks) {
      book.favorites = validIds.contains(book.id) ? 1 : 0;
    }

    notifyListeners();
  }

  /// Ajouter ou retirer un favori
  Future<void> toggleFavorite(Book book) async {
    final dbService = DatabaseService();

    if (_favorites.contains(book)) {
      _favorites.remove(book);
      book.favorites = (book.favorites - 1).clamp(0, 999999);
      await dbService.removeFavorite(book.id);
    } else {
      _favorites.add(book);
      book.favorites += 1;
      await dbService.addFavorite(book.id, book.title, book.genre);
    }

    notifyListeners();
  }

  /// Savoir si un livre est en favori
  bool isFavorite(Book book) {
    return _favorites.contains(book);
  }
}
