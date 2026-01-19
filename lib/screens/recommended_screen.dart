// lib/screens/recommendations_screen.dart

import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/recommendation_service.dart';
import '../services/database_service.dart';
import '../widgets/book_card.dart';
import '../theme/app_theme.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  final RecommendationService _recoService = RecommendationService();
  final DatabaseService _db = DatabaseService();
  bool _loading = true;
  List<Book> _recommendedBooks = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final books = await _db.getAllBooks();
    final history = await _db.getHistoryBooks();
    final favorites = await _db.getFavorites();

    final recommended = _recoService.recommend(
      books: books,
      history: history,
      favorites: favorites,
      limit: 12,
    );

    if (!mounted) return;
    setState(() {
      _recommendedBooks = recommended;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommandés pour vous"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: AppTheme.primaryViolet,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1B24) : Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _recommendedBooks.isEmpty
                    ? const Center(
                        child: Text(
                          "Aucune recommandation disponible",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _recommendedBooks.length,
                        itemBuilder: (context, index) {
                          final book = _recommendedBooks[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: BookCard(
                              book: book,
                              heroTag: 'recommended_${book.id}',
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
    );
  }
}
