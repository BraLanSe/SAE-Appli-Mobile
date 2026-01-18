import '../models/book.dart';

class RecommendationService {
  /// Retourne une liste de livres triés selon un score
  List<Book> recommend({
    required List<Book> books,
    List<Book> history = const [],
    List<Book> favorites = const [],
    int limit = 10,
  }) {
    if (books.isEmpty) return [];

    final favoriteGenre = _getFavoriteGenre(history, favorites);
    final historyIds = history.map((b) => b.id).toSet();
    final favoriteIds = favorites.map((b) => b.id).toSet();

    final scored = books.map((book) {
      double score = 0;

      // Base : popularité normalisée
      score += ((book.popularity ?? 0) / 10.0);

      // Favori utilisateur
      if (favoriteIds.contains(book.id) || book.favorites > 0) {
        score += 5;
      }

      // Historique / clics
      if (historyIds.contains(book.id) || book.clicks > 0) {
        score += 2 + (book.clicks * 0.5);
      }

      // Temps de lecture (plafonné)
      score += (book.minutesRead / 30.0).clamp(0, 6);

      // Bonus genre préféré
      if (favoriteGenre != null && book.genre == favoriteGenre) {
        score += 3;
      }

      return MapEntry(book, score);
    }).toList();

    scored.sort((a, b) {
      final scoreCompare = b.value.compareTo(a.value);
      if (scoreCompare != 0) return scoreCompare;
      return (b.key.popularity ?? 0).compareTo(a.key.popularity ?? 0);
    });

    return scored.map((e) => e.key).take(limit).toList();
  }

  String? _getFavoriteGenre(List<Book> history, List<Book> favorites) {
    final Map<String, int> counts = {};
    for (final book in history) {
      counts[book.genre] = (counts[book.genre] ?? 0) + 1;
    }
    for (final book in favorites) {
      counts[book.genre] = (counts[book.genre] ?? 0) + 2;
    }

    if (counts.isEmpty) return null;

    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
