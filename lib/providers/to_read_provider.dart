import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class ToReadProvider extends ChangeNotifier {
  List<Book> _toReadList = [];

  List<Book> get toReadList => _toReadList;

  /// Charger la liste "À lire" depuis SharedPreferences
  Future<void> loadToReadList(List<Book> allBooks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedTitles = prefs.getStringList('to_read_books') ?? [];

    _toReadList =
        allBooks.where((book) => savedTitles.contains(book.title)).toList();
    notifyListeners();
  }

  /// Ajouter ou retirer de la liste "À lire"
  Future<void> toggleToRead(Book book) async {
    final prefs = await SharedPreferences.getInstance();

    if (_toReadList.contains(book)) {
      _toReadList.remove(book);
    } else {
      _toReadList.add(book);
    }

    // Sauvegarde des titres
    List<String> titles = _toReadList.map((b) => b.title).toList();
    await prefs.setStringList('to_read_books', titles);

    notifyListeners();
  }

  /// Savoir si un livre est dans la liste "À lire"
  bool isToRead(Book book) {
    return _toReadList.contains(book);
  }
}
