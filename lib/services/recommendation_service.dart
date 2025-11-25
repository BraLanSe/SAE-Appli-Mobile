import '../models/book.dart';

class RecommendationService {
  final List<Book> _allBooks;

  RecommendationService(this._allBooks);

  /// Retourne une liste de livres triés selon leur score
  List<Book> recommend({String? favoriteGenre, int limit = 10}) {
    List<Book> filtered = _allBooks;

    // Filtrer par genre préféré
    if (favoriteGenre != null && favoriteGenre.isNotEmpty) {
      filtered = filtered.where((b) => b.genre == favoriteGenre).toList();
    }

    // Trier par score décroissant
    filtered.sort((a, b) => b.score.compareTo(a.score));

    // Limiter le nombre de résultats
    if (filtered.length > limit) {
      return filtered.take(limit).toList();
    }

    return filtered;
  }
}
