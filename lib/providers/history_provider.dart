import 'package:flutter/material.dart';
import 'user_profile_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../utils/data.dart'; // Pour retrouver le livre entier par titre/id

class HistoryProvider extends ChangeNotifier {
  final UserProfileProvider userProfile;
  final List<Book> _history = [];

  HistoryProvider(this.userProfile);

  List<Book> get history => List.unmodifiable(_history.reversed);

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyTitles = prefs.getStringList('history_books') ?? [];

    // On reconstruit la liste en cherchant dans allBooks
    // (Dans un vrai cas, on stockerait les ID ou un modèle complet JSON)
    _history.clear();
    for (var title in historyTitles) {
      try {
        final book = allBooks.firstWhere((b) => b.title == title,
            orElse: () => Book(
                  id: '0',
                  title: title,
                  author: 'Inconnu',
                  genre: 'Inconnu',
                  imagePath: '',
                  description: '',
                  clicks: 0,
                  popularity: 0,
                ));
        if (book.imagePath.isNotEmpty) {
          _history.add(book);
        }
      } catch (e) {
        // Ignorer si livre non trouvé
      }
    }
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    // On sauvegarde simplement la liste des titres (dans l'ordre d'ajout)
    // Note: _history est modifiée, donc on la sauvegarde telle quelle
    List<String> titles = _history.map((b) => b.title).toList();
    await prefs.setStringList('history_books', titles);
  }

  void addToHistory(Book book) {
    // Évite les doublons : supprime si déjà présent
    _history.removeWhere((b) => b.title == book.title);
    _history.add(book);
    _saveHistory();

    // Ajout d'XP pour la lecture
    userProfile.addXp(20);

    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }
}
