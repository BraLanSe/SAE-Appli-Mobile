import '../models/book.dart';
import 'recommendation_engine.dart';

class RecommendationService {
  final List<Book> _allBooks;
  final RecommendationEngine _engine = RecommendationEngine();

  RecommendationService(this._allBooks);

  /// Retourne une liste de livres recommandés (Content-Based)
  List<Book> recommend({
    required List<Book> favorites,
    required List<Book> history,
    int limit = 10,
  }) {
    // Utiliser le nouveau moteur
    final recommendations =
        _engine.recommendBooks(_allBooks, favorites, history);

    // Limiter le nombre de résultats
    if (recommendations.length > limit) {
      return recommendations.take(limit).toList();
    }

    return recommendations;
  }
}
