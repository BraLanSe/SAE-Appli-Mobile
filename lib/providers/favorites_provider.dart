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
    notifyListeners();
  }

  /// Ajouter ou retirer un favori
  Future<void> toggleFavorite(Book book) async {
    final prefs = await SharedPreferences.getInstance();

    if (_favorites.contains(book)) {
      _favorites.remove(book);
    } else {
      _favorites.add(book);
    }

    // Sauvegarde
    List<String> titles = _favorites.map((book) => book.title).toList();
    await prefs.setStringList('favorites', titles);

    notifyListeners();
  }

  bool isFavorite(Book book) {
    return _favorites.contains(book);
  }
}
