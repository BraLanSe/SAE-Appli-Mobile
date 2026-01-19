// lib/screens/recommendations_screen.dart

import 'package:flutter/material.dart';
import '../services/recommendation_service.dart';
import '../utils/data.dart';
import '../widgets/book_card.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late RecommendationService _recoService;

  @override
  void initState() {
    super.initState();
    _recoService = RecommendationService(allBooks);
  }

  @override
  Widget build(BuildContext context) {
    final recommendedBooks = _recoService.recommend();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommandés pour vous"),
        backgroundColor: Colors.deepPurple,
      ),
      body: recommendedBooks.isEmpty
          ? const Center(
              child: Text(
                "Aucune recommandation disponible",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: recommendedBooks.length,
              itemBuilder: (context, index) {
                final book = recommendedBooks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BookCard(
                    book: book,
                    heroTag: "${book.id}_reco",
                  ),
                );
              },
            ),
    );
  }
}
