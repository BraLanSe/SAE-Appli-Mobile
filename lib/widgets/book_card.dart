import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final String heroTag;

  const BookCard({
    super.key,
    required this.book,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final bool isFavorite = favoritesProvider.isFavorite(book);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // Requested radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Lighter shadow
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            /// Ajout : le clic augmente le score de recommandations
            book.clicks++;

            /// Ajout dans l’historique
            final historyProvider =
                Provider.of<HistoryProvider>(context, listen: false);
            historyProvider.addToHistory(book);

            /// Aller au détail
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailScreen(
                  book: book,
                  heroTag: heroTag,
                ),
              ),
            );
          },
          child: Row(
            children: [
              /// ---- IMAGE ----
              Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.asset(
                    book.imagePath,
                    width: 90, // Slightly larger
                    height: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      height: 130,
                      color: Colors.grey[300],
                      child:
                          const Icon(Icons.book, size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),

              /// ---- TEXTE ----
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16), // Increased padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Titre
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily:
                              'Playfair Display', // Using the new font for titles
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      /// Auteur
                      Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Genre tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          book.genre,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ---- FAVORIS ----
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[400],
                      ),
                      onPressed: () {
                        favoritesProvider.toggleFavorite(book);
                      },
                    ),
                    if (book.favorites > 0)
                      Text(
                        '${book.favorites}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
