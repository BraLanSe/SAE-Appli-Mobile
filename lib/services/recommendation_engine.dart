import '../models/book.dart';

class RecommendationEngine {
  // French stop words to ignore in analysis
  static const Set<String> stopWords = {
    'le',
    'la',
    'les',
    'un',
    'une',
    'des',
    'de',
    'du',
    'au',
    'aux',
    'et',
    'ou',
    'mais',
    'donc',
    'or',
    'ni',
    'car',
    'ce',
    'cet',
    'cette',
    'ces',
    'mon',
    'ton',
    'son',
    'notre',
    'votre',
    'leur',
    'il',
    'elle',
    'ils',
    'elles',
    'je',
    'tu',
    'nous',
    'vous',
    'qui',
    'que',
    'quoi',
    'dont',
    'où',
    'est',
    'sont',
    'a',
    'ont',
    'fut',
    'furent',
    'été',
    'dans',
    'sur',
    'sous',
    'par',
    'pour',
    'avec',
    'sans',
    'plus',
    'moins',
    'très',
    'trop',
    'peu',
    'bessac'
  };

  /// Main method: Recommend books based on user history and favorites
  List<Book> recommendBooks(
      List<Book> allBooks, List<Book> favorites, List<Book> history) {
    if (favorites.isEmpty && history.isEmpty) {
      // Fallback: Return by popularity if no data
      final sorted = List<Book>.from(allBooks);
      sorted.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
      return sorted;
    }

    // 1. Build User Profile
    final profile = _buildUserProfile(favorites, history);

    // 2. Score each candidate book
    final Map<String, double> bookScores = {};
    for (var book in allBooks) {
      // Skip books already known (in favorites)
      // We keep history books to allow re-reading suggestions, but maybe lower score?
      // For now, let's exclude favorites only.
      if (favorites.any((f) => f.id == book.id)) {
        continue;
      }

      final score = _calculateScore(book, profile);
      bookScores[book.id] = score;
    }

    // 3. Sort by score
    final recommendations = List<Book>.from(allBooks)
      ..retainWhere((b) => bookScores.containsKey(b.id)) // Only kept ones
      ..sort((a, b) {
        final scoreA = bookScores[a.id] ?? 0;
        final scoreB = bookScores[b.id] ?? 0;
        return scoreB.compareTo(scoreA); // Descending
      });

    return recommendations;
  }

  UserProfile _buildUserProfile(List<Book> favorites, List<Book> history) {
    final profile = UserProfile();

    // Favorites have higher weight (e.g. 2.0)
    for (var book in favorites) {
      _processBookIntoProfile(profile, book, weight: 2.0);
    }

    // History has standard weight (e.g. 1.0)
    for (var book in history) {
      _processBookIntoProfile(profile, book, weight: 1.0);
    }

    return profile;
  }

  void _processBookIntoProfile(UserProfile profile, Book book,
      {required double weight}) {
    // Genre
    profile.genreScores.update(book.genre, (val) => val + (5.0 * weight),
        ifAbsent: () => 5.0 * weight);

    // Author
    profile.authorScores.update(book.author, (val) => val + (3.0 * weight),
        ifAbsent: () => 3.0 * weight);

    // Keywords from Description
    final words = _extractKeywords(book.description);
    for (var word in words) {
      profile.keywordScores.update(word, (val) => val + (1.0 * weight),
          ifAbsent: () => 1.0 * weight);
    }
  }

  double _calculateScore(Book book, UserProfile profile) {
    double score = 0.0;

    // 1. Genre Match
    if (profile.genreScores.containsKey(book.genre)) {
      score += profile.genreScores[book.genre]!;
    }

    // 2. Author Match
    if (profile.authorScores.containsKey(book.author)) {
      score += profile.authorScores[book.author]!;
    }

    // 3. Keyword Match (Content-Based)
    final words = _extractKeywords(book.description);
    for (var word in words) {
      if (profile.keywordScores.containsKey(word)) {
        // We normalize slightly to avoid long descriptions having overly massive advantage
        // But for MVP, simple sum is fine.
        score += profile.keywordScores[word]! * 0.5;
      }
    }

    // 4. Boost by popularity (small factor to break ties with quality)
    score += (book.popularity ?? 0) * 0.01;

    return score;
  }

  List<String> _extractKeywords(String text) {
    // Remove punctuation, lowercase
    final cleanText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    final words = cleanText.split(RegExp(r'\s+'));

    return words.where((w) => w.length > 2 && !stopWords.contains(w)).toList();
  }
}

class UserProfile {
  final Map<String, double> genreScores = {};
  final Map<String, double> authorScores = {};
  final Map<String, double> keywordScores = {};
}
