import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/book_card.dart';
import 'main_screen.dart';

import '../widgets/fade_in_animation.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteBooks = favoritesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes favoris"),
        // backgroundColor: Colors.deepPurple, // Removed
      ),
      body: favoriteBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80,
                      color: Colors.deepPurple.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  const Text(
                    "Aucun favori pour le moment",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Explorez la bibliothèque pour ajouter\n des livres à votre liste.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      MainScreen.switchToTab(context, 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Découvrir des livres"),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoriteBooks.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 0), // Card has its own margin
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return FadeInAnimation(
                    delay: index,
                    child: BookCard(book: book, heroTag: book.id));
              },
            ),
    );
  }
}
