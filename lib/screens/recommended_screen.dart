import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/recommendation_service.dart';
import '../utils/data.dart';
import '../widgets/book_card.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';

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
    // 1. Récupérer les données utilisateur via les Providers
    final favorites = Provider.of<FavoritesProvider>(context).favorites;
    final history = Provider.of<HistoryProvider>(context).history;

    // 2. Générer les recommandations
    final recommendedBooks = _recoService.recommend(
      favorites: favorites,
      history: history,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recommandés pour vous"),
        // backgroundColor: Colors.deepPurple, // Removed to use Theme
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
