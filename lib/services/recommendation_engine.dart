import 'dart:math';
import '../models/book.dart';
import '../models/recommendation_result.dart';

class RecommendationEngine {
  /// Computes a list of recommended books based on user history and favorites.
  ///
  /// [allBooks] The entire catalog of books.
  /// [userHistory] List of books the user has interacted with/read.
  /// [userFavorites] List of books the user has marked as favorite.
  /// [limit] Maximum number of recommendations to return (default 5).
  static List<RecommendationResult> compute({
    required List<Book> allBooks,
    required List<Book> userHistory,
    required List<Book> userFavorites,
    int limit = 5,
  }) {
    // 1. Calculate Affinities (Genres & Authors)
    final Map<String, int> genreScores = {};
    final Map<String, int> authorScores = {};

    void addGenreScore(String genre, int points) {
      genreScores[genre] = (genreScores[genre] ?? 0) + points;
    }

    void addAuthorScore(String author, int points) {
      authorScores[author] = (authorScores[author] ?? 0) + points;
    }

    // +5 points for favorite genres, +3 for favorite authors
    for (var book in userFavorites) {
      addGenreScore(book.genre, 5);
      addAuthorScore(book.author, 3);
    }

    // +2 points for history genres, +1 for history authors
    for (var book in userHistory) {
      addGenreScore(book.genre, 2);
      addAuthorScore(book.author, 1);
    }

    // If no data, return popular books as recommendations with a generic reason
    if (genreScores.isEmpty && authorScores.isEmpty) {
      return allBooks
          .take(limit)
          .map((b) => RecommendationResult(
                book: b,
                score: 0,
                matchPercentage: 0,
                reason: "Populaire en ce moment",
              ))
          .toList();
    }

    // 2. Score Candidates
    final List<RecommendationResult> scoredCandidates = [];

    // Exclude books already read or favorited
    final excludeIds = {
      ...userHistory.map((b) => b.id),
      ...userFavorites.map((b) => b.id),
    };

    // Calculate max potential score effectively found in this dataset to normalize percentage properly
    // However, a fixed "perfect score" is easier to understand.
    // Let's say: Genre Match (5) + Author Match (3) = 8 is a very high base score.
    // We'll normalize against 10 for a "100%" match, capping at 100%.
    const double maxReferenceScore = 10.0;

    for (var book in allBooks) {
      if (excludeIds.contains(book.id)) continue;

      double score = 0;
      List<String> reasons = [];

      // Genre Score
      int gScore = genreScores[book.genre] ?? 0;
      if (gScore > 0) {
        // Logarithmic scaling to prevent one genre dominating too much if read 100 times
        // but simpler: just capped or raw. Let's use raw but capped contribution per category?
        // Actually, simple add is fine for now.
        // We'll scale it down a bit so it doesn't explode.
        double normalizedGenreScore = min(gScore.toDouble(), 10.0);
        score += normalizedGenreScore;
        reasons.add("Genre: ${book.genre}");
      }

      // Author Score
      // Author Score
      int aScore = authorScores[book.author] ?? 0;
      if (aScore > 0) {
        score += 3.0; // Bonus for author
        reasons.add("Auteur similaire");
      }

      // Popularity boost (small)
      if ((book.popularity ?? 0) > 95) {
        score += 0.5;
        // Don't add reason to keep it clean, unless it's the only reason
      }

      if (score > 0) {
        // Randomization factor (slight jitter) to rotate similar scoring books
        score += (Random().nextDouble() * 0.5);

        int matchPercent = ((score / maxReferenceScore) * 100).round();
        if (matchPercent > 98) {
          matchPercent = 98;
        }

        String mainReason =
            reasons.isNotEmpty ? reasons.join(" • ") : "Recommandé pour vous";

        scoredCandidates.add(RecommendationResult(
          book: book,
          score: score,
          matchPercentage: matchPercent,
          reason: mainReason,
        ));
      }
    }

    // 3. Sort by Score (Descending)
    scoredCandidates.sort((a, b) => b.score.compareTo(a.score));

    // 4. Extract Top N
    List<RecommendationResult> results = scoredCandidates.take(limit).toList();

    // 5. Fallback if not enough recommendations
    if (results.length < limit) {
      final remainingCount = limit - results.length;
      final existingIds = {...excludeIds, ...results.map((r) => r.book.id)};

      final fallbackBooks = allBooks
          .where((b) => !existingIds.contains(b.id))
          .take(remainingCount);

      for (var book in fallbackBooks) {
        results.add(RecommendationResult(
          book: book,
          score: 0,
          matchPercentage: 0,
          reason: "Découverte",
        ));
      }
    }

    return results;
  }
}
