import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class HistoryProvider extends ChangeNotifier {
  List<Book> _history = [];
  final db = DatabaseService();

  HistoryProvider() {
    loadHistory();
  }

  List<Book> get history => List.unmodifiable(_history.reversed);

  Future<void> loadHistory() async {
    _history = await db.getHistoryBooks();
    notifyListeners();
  }

  Future<void> addToHistory(Book book) async {
    book.clicks += 1;
    await db.updateUserStat(book.id, addClicks: 1);
    await db.addToHistory(book.id);
    await loadHistory();
  }

  /// 🔥 AJOUT IMPORTANT
  Future<void> updateBookTime(Book book, double minutesToAdd) async {
    book.minutesRead += minutesToAdd;
    await db.updateUserStat(book.id, addTime: minutesToAdd);
    await db.addToHistory(book.id);
    await loadHistory();
  }

  Future<void> removeFromHistory(String id) async {
    final dbInstance = await db.database;
    await dbInstance.delete('history', where: 'bookId = ?', whereArgs: [id]);
    _history.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    final dbInstance = await db.database;
    await dbInstance.delete('history');
    _history.clear();
    notifyListeners();
  }
}
