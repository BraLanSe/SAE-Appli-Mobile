import 'package:flutter/material.dart';
import 'user_profile_provider.dart';
import '../models/book.dart';
import '../utils/data.dart'; // Pour retrouver le livre entier par titre/id
import '../services/database_service.dart';

class HistoryProvider extends ChangeNotifier {
  final UserProfileProvider userProfile;
  final List<Book> _history = [];

  HistoryProvider(this.userProfile);

  List<Book> get history => List.unmodifiable(
      _history); // Déjà trié par la requête SQL si on veut, ou on garde reversed ici si on push à la fin

  Future<void> loadHistory() async {
    final dbService = DatabaseService();
    List<String> historyIds = await dbService
        .getHistory(); // IDs triés par date décroissante (plus récent en premier)

    _history.clear();
    for (var id in historyIds) {
      try {
        final book = allBooks.firstWhere((b) => b.id == id,
            orElse: () => Book(
                  id: '0',
                  title: 'Inconnu',
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
        // Ignorer
      }
    }
    notifyListeners();
  }

  Future<void> addToHistory(Book book) async {
    // Évite les doublons visuels immédiats, mais la DB gère aussi l'upsert
    _history.removeWhere((b) => b.id == book.id);
    _history.insert(
        0, book); // Ajout au début car on a chargé par ordre décroissant

    final dbService = DatabaseService();
    await dbService.addToHistory(book.id, book.title, book.genre);

    // Ajout d'XP pour la lecture
    userProfile.addXp(20);

    notifyListeners();
  }

  Future<void> clearHistory() async {
    _history.clear();
    final dbService = DatabaseService();
    await dbService.clearHistory();
    notifyListeners();
  }
}
