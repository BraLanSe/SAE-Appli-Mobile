import 'package:flutter_test/flutter_test.dart';
import 'package:bookwise/providers/filter_provider.dart';

void main() {
  group('FilterProvider Tests', () {
    late FilterProvider provider;

    setUp(() {
      provider = FilterProvider();
    });

    test('Initial state should be All genres and empty search', () {
      expect(provider.selectedGenre, 'All');
      expect(provider.searchQuery, '');
    });

    test('setGenre should update selectedGenre and notify listeners', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.setGenre('Fantasy');
      expect(provider.selectedGenre, 'Fantasy');
      expect(notified, true);
    });

    test('setSearchQuery should update searchQuery and notify listeners', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      provider.setSearchQuery('Harry Potter');
      expect(provider.searchQuery, 'Harry Potter');
      expect(notified, true);
    });

    test('reset should clear filters', () {
      provider.setGenre('Sci-Fi');
      provider.setSearchQuery('Dune');

      provider.reset();

      expect(provider.selectedGenre, 'All');
      expect(provider.searchQuery, '');
    });
  });
}
