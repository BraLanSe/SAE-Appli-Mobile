import 'dart:math';
import '../models/book.dart';
import '../models/recommendation_result.dart';
import 'database_service.dart';
import '../utils/performance_monitor.dart';

class RecommendationEngine {
  /// Computes a list of recommended books based on user history and favorites from SQLite.
  /// Uses PerformanceMonitor to log execution time.
  static Future<List<RecommendationResult>> compute({
    required List<Book> allBooks,
    int limit = 5,
  }) async {
    final monitor = PerformanceMonitor();

    // Log battery at start of heavy process
    await monitor.logBatteryStats();

    return await monitor.measureAsync<List<RecommendationResult>>(
      "Recommendation Algorithm",
      () async {
        // 1. Fetch User Preferences from SQLite
        final dbService = DatabaseService();
        final preferredGenres = await dbService.getPreferredGenres();

        // Simulating a "heavy" process for demonstration of monitoring if needed
        // await Future.delayed(const Duration(milliseconds: 20));

        // 2. Filter & Score
        // Strategy: "Trouve les 3 genres les plus fréquents... et sors 5 livres aléatoires"

        List<RecommendationResult> results = [];
        final random = Random();

        if (preferredGenres.isNotEmpty) {
          // Filter books that match preferred genres
          final candidateBooks =
              allBooks.where((b) => preferredGenres.contains(b.genre)).toList();

          // Shuffle to get "random" books from these genres
          candidateBooks.shuffle(random);

          // Take top N
          for (var book in candidateBooks.take(limit)) {
            // Score calculation (simplified for this task constraints)
            // 5 base points + random jitter
            double score = 5.0 + random.nextDouble();

            // Calculate specific reason
            String reason = "Genre favori : ${book.genre}";

            results.add(RecommendationResult(
              book: book,
              score: score,
              matchPercentage:
                  (85 + random.nextInt(14)), // Random 85-99% for "good" matches
              reason: reason,
            ));
          }
        }

        // 3. Fallback / Discovery
        // If we don't have enough books (or no preferred genres yet), fill with popular/random books
        if (results.length < limit) {
          final existingIds = results.map((r) => r.book.id).toSet();

          // Get popular books not already selected
          final fallbackBooks = allBooks
              .where((b) => !existingIds.contains(b.id))
              .toList()
            ..sort((a, b) => (b.popularity ?? 0)
                .compareTo(a.popularity ?? 0)); // Sort by popularity

          for (var book in fallbackBooks.take(limit - results.length)) {
            results.add(RecommendationResult(
              book: book,
              score: 1.0,
              matchPercentage: 50 + random.nextInt(20),
              reason: "Tendance actuelle",
            ));
          }
        }

        return results;
      },
    );
  }
}
