import 'package:flutter/material.dart';
import '../models/book.dart';

class HistoryProvider extends ChangeNotifier {
  final List<Book> _history = [];

  List<Book> get history => List.unmodifiable(_history.reversed);

  void addToHistory(Book book) {
    // Évite les doublons : supprime si déjà présent
    _history.removeWhere((b) => b.title == book.title);
    _history.add(book);
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    notifyListeners();
  }
}
