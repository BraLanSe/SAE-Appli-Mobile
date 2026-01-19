import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {
  String _selectedGenre = "All";
  String _searchQuery = "";

  String get selectedGenre => _selectedGenre;
  String get searchQuery => _searchQuery;

  void setGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void reset() {
    _selectedGenre = "All";
    _searchQuery = "";
    notifyListeners();
  }
}
