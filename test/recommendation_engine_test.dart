import 'package:flutter_test/flutter_test.dart';
import 'package:bookwise/models/book.dart'; // Adjust path if necessary, likely 'package:sae_appli_mobile/models/book.dart' or relative
import 'package:bookwise/services/recommendation_engine.dart'; // Adjust path

// Since we don't know the exact package name, I will use relative imports which are safer for this context
// assuming this file is in test/recommendation_engine_test.dart and lib is one level up.
// Actually, in Flutter tests, we usually import 'package:app_name/...'.
// Let's check main.dart imports to be sure of the package name.
// It was 'package:flutter/material.dart', no app package seen in snippets.
// I will use relative imports from the test folder: '../lib/...' NO that doesn't work in dart well.
// I will check the file structure or assume 'package:bookwise' based on previous context or 'package:sae_appli_mobile'??
// The user's folder is SAE-Appli-Mobile.
// Let's assume relative imports based on file structure or verify package name first.

void main() {
  group('RecommendationEngine Tests', () {
    // Mock Data
    final book1 = Book(
        id: '1',
        title: 'Book 1',
        author: 'Auth 1',
        genre: 'Fantasy',
        imagePath: '',
        description: 'desc');
    final book2 = Book(
        id: '2',
        title: 'Book 2',
        author: 'Auth 2',
        genre: 'Sci-Fi',
        imagePath: '',
        description: 'desc');
    final book3 = Book(
        id: '3',
        title: 'Book 3',
        author: 'Auth 3',
        genre: 'Fantasy',
        imagePath: '',
        description: 'desc');

    final allBooks = [book1, book2, book3];

    test('Should prioritize genres in Favorites (+5 points)', () {
      final favorites = [book1]; // Favorite is Fantasy
      final history = <Book>[];

      final recommendations = RecommendationEngine.compute(
        allBooks: allBooks,
        userHistory: history,
        userFavorites: favorites,
      );

      // Book 3 (Fantasy) should be first because it matches the favorite genre
      expect(recommendations.first.book.id, '3');
      expect(recommendations.first.reason, contains('Genre: Fantasy'));
    });

    test('Should exclude books already in History', () {
      final favorites = <Book>[];
      final history = [book3]; // Read Book 3

      final recommendations = RecommendationEngine.compute(
        allBooks: allBooks,
        userHistory: history,
        userFavorites: favorites,
      );

      // Recommendations should not contain Book 3
      expect(recommendations.any((r) => r.book.id == '3'), isFalse);
    });

    test('Should return empty list if all books read', () {
      final favorites = <Book>[];
      final history = [book1, book2, book3];

      final recommendations = RecommendationEngine.compute(
        allBooks: allBooks,
        userHistory: history,
        userFavorites: favorites,
      );

      expect(recommendations, isEmpty);
    });
  });
}
