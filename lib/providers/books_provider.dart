import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/data.dart';

class BooksProvider extends ChangeNotifier {
  // Source data
  final List<Book> _allBooks = allBooks;

  // Filter states
  String _searchQuery = "";
  String _selectedGenre = "All";
  String _selectedSort = "A-Z";

  // Constants / Configuration
  final List<String> _genres = [
    "All",
    "Fiction",
    "Science-Fiction",
    "Fantasy",
    "Roman Philosophique",
    "Classique",
    "Horreur",
    "Romance",
    "Poésie",
    "Thriller Psychologique",
    "Cyberpunk",
    "Satire",
    "Drame",
  ];

  final List<String> _sortOptions = [
    "A-Z",
    "Z-A",
    "Plus populaire",
    "Date ajout",
  ];

  // Getters for state
  String get searchQuery => _searchQuery;
  String get selectedGenre => _selectedGenre;
  String get selectedSort => _selectedSort;
  List<String> get genres => _genres;
  List<String> get sortOptions => _sortOptions;

  // Cache for filtered books
  List<Book>? _cachedFilteredBooks;

  // Computed property for UI
  List<Book> get filteredBooks {
    if (_cachedFilteredBooks != null) {
      return _cachedFilteredBooks!;
    }

    List<Book> books = [..._allBooks];

    // 1. Filter by Genre
    if (_selectedGenre != "All") {
      books = books
          .where((b) => b.genre.toLowerCase() == _selectedGenre.toLowerCase())
          .toList();
    }

    // 2. Filter by Search (Title or Author)
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      books = books
          .where((b) =>
              b.title.toLowerCase().contains(queryLower) ||
              b.author.toLowerCase().contains(queryLower))
          .toList();
    }

    // 3. Sort
    switch (_selectedSort) {
      case "A-Z":
        books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Z-A":
        books.sort((a, b) => b.title.compareTo(a.title));
        break;
      case "Plus populaire":
        books.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
        break;
      case "Date ajout":
        books.sort((a, b) => (b.dateAdded ?? DateTime(2000))
            .compareTo(a.dateAdded ?? DateTime(2000)));
        break;
    }

    _cachedFilteredBooks = books;
    return books;
  }

  // Setters (Actions)
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _cachedFilteredBooks = null; // Invalidate cache
      notifyListeners();
    }
  }

  void setGenre(String genre) {
    if (_selectedGenre != genre) {
      _selectedGenre = genre;
      _cachedFilteredBooks = null; // Invalidate cache
      notifyListeners();
    }
  }

  void setSort(String sort) {
    if (_selectedSort != sort) {
      _selectedSort = sort;
      _cachedFilteredBooks = null; // Invalidate cache
      notifyListeners();
    }
  }
}
