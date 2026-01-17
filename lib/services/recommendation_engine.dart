import '../models/book.dart';

class RecommendationEngine {
  /// Computes a list of recommended books based on user history and favorites.
  ///
  /// [allBooks] The entire catalog of books.
  /// [userHistory] List of books the user has interacted with/read.
  /// [userFavorites] List of books the user has marked as favorite.
  /// [limit] Maximum number of recommendations to return (default 5).
  static List<Book> compute({
    required List<Book> allBooks,
    required List<Book> userHistory,
    required List<Book> userFavorites,
    int limit = 5,
  }) {
    // 1. Calculate Genre Scores
    // We want to know which genres the user likes most.
    final Map<String, int> genreScores = {};

    // Helper to add points
    void addScore(String genre, int points) {
      genreScores[genre] = (genreScores[genre] ?? 0) + points;
    }

    // +5 points for favorite genres
    for (var book in userFavorites) {
      addScore(book.genre, 5);
      // Optional: Maybe author score too?
    }

    // +2 points for history genres
    for (var book in userHistory) {
      addScore(book.genre, 2);
    }

    // If no data, return random or popular books
    if (genreScores.isEmpty) {
      // Return trending or just shuffle for variety
      // For now, let's just return a sublist to keep it simple
      return allBooks.take(limit).toList();
    }

    // 2. Score Candidates
    // We look at all books the user hasn't read yet.
    final List<MapEntry<Book, int>> candidateScores = [];

    // Create a set of IDs to exclude (already read/favorited)
    // We assume if it's in history, we don't recommend it again immediately
    final excludeIds = {
      ...userHistory.map((b) => b.id),
      // We might want to recommend favorites again? No, usually discovery is better.
      ...userFavorites.map((b) => b.id),
    };

    for (var book in allBooks) {
      if (excludeIds.contains(book.id)) continue;

      int score = 0;

      // Base score from genre affinity
      score += genreScores[book.genre] ?? 0;

      // Only add if it has some relevance (score > 0)
      // Or maybe we want to include popular ones with low score?
      // Let's stick to relevance for "Recommended".
      if (score > 0) {
        candidateScores.add(MapEntry(book, score));
      }
    }

    // 3. Sort by Score (Descending)
    candidateScores.sort((a, b) => b.value.compareTo(a.value));

    // 4. Extract Books
    List<Book> recommendations =
        candidateScores.map((entry) => entry.key).take(limit).toList();

    // Fallback: If we don't have enough recommendations (e.g. only read 1 genre, and we read all books of that genre),
    // fill coming up short with general popular books.
    if (recommendations.length < limit) {
      final remainingCount = limit - recommendations.length;
      final existingIds = {...excludeIds, ...recommendations.map((b) => b.id)};

      final fallbackBooks = allBooks
          .where((b) => !existingIds.contains(b.id))
          .take(remainingCount);

      recommendations.addAll(fallbackBooks);
    }

    return recommendations;
  }
}
