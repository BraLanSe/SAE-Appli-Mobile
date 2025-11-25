import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Book> _favorites = [];

  List<Book> get favorites => _favorites;

  /// Charger les favoris depuis SharedPreferences
  Future<void> loadFavorites(List<Book> allBooks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedTitles = prefs.getStringList('favorites') ?? [];

    _favorites = allBooks.where((book) => savedTitles.contains(book.title)).toList();

    // Mettre à jour le compteur favorites
    for (var book in allBooks) {
      book.favorites = savedTitles.contains(book.title) ? 1 : 0;
    }

    notifyListeners();
  }

  /// Ajouter ou retirer un favori
  Future<void> toggleFavorite(Book book) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favorites.contains(book)) {
      _favorites.remove(book);
      book.favorites = (book.favorites - 1).clamp(0, 999999); // éviter négatifs
    } else {
      _favorites.add(book);
      book.favorites += 1;
    }

    // Sauvegarde des favoris par titre
    List<String> titles = _favorites.map((b) => b.title).toList();
    await prefs.setStringList('favorites', titles);

    notifyListeners();
  }

  /// Savoir si un livre est en favori
  bool isFavorite(Book book) {
    return _favorites.contains(book);
  }
}
