import '../models/book.dart';

class StatisticsService {
  static Map<String, double> getGenreDistribution(List<Book> books) {
    if (books.isEmpty) return {};

    Map<String, int> counts = {};
    for (var book in books) {
      counts[book.genre] = (counts[book.genre] ?? 0) + 1;
    }

    Map<String, double> distribution = {};
    counts.forEach((key, value) {
      distribution[key] = (value / books.length) * 100;
    });

    return distribution;
  }

  static String getMostPopularGenre(List<Book> books) {
    if (books.isEmpty) return "N/A";

    Map<String, int> counts = {};
    for (var book in books) {
      counts[book.genre] = (counts[book.genre] ?? 0) + 1;
    }

    var sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key;
  }

  static double getDiversityScore(List<Book> books) {
    if (books.isEmpty) return 0.0;

    Set<String> uniqueAuthors = books.map((b) => b.author).toSet();
    // A score of 1.0 means every book has a different author (Maximum diversity)
    return (uniqueAuthors.length / books.length) * 100;
  }

  static double getAveragePopularity(List<Book> books) {
    if (books.isEmpty) return 0.0;

    int totalPop = books.fold(0, (sum, item) => sum + (item.popularity ?? 0));
    return totalPop / books.length;
  }

  static int getTotalPagesRead(List<Book> books) {
    if (books.isEmpty) return 0;
    return books.fold(0, (sum, book) => sum + book.pageCount);
  }

  static double getAverageBookLength(List<Book> books) {
    if (books.isEmpty) return 0.0;
    return getTotalPagesRead(books) / books.length;
  }

  static String getReadingPersonality(List<Book> books) {
    if (books.isEmpty) return "Novice";

    final int count = books.length;
    final double diversity = getDiversityScore(books); // 0 to 100
    final int totalPages = getTotalPagesRead(books);

    if (count > 20 && diversity > 80) return "Érudit Polyvalent";
    if (count > 20) return "Grand Lecteur";
    if (totalPages > 5000) return "Dévoreur de Pages";
    if (diversity > 80) return "Explorateur";
    if (count > 5) return "Lecteur Régulier";

    return "Découvreur";
  }
}
