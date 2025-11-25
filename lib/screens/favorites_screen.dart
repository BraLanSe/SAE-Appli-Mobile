import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/book_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteBooks = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes favoris"),
        backgroundColor: Colors.deepPurple,
      ),
      body: favoriteBooks.isEmpty
          ? const Center(child: Text("Aucun favori pour le moment", style: TextStyle(fontSize: 16)))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoriteBooks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return BookCard(book: book, heroTag: book.id);
              },
            ),
    );
  }
}
