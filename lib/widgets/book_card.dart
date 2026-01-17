import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/favorites_provider.dart';
import '../providers/history_provider.dart';
import '../screens/book_detail_screen.dart';
import 'shimmer_loading.dart';
import 'like_button.dart';

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

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor, // Use theme card color
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black
                    .withValues(alpha: 0.3) // Stronger shadow for dark mode
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDarkMode
            ? Border.all(color: Colors.white.withValues(alpha: 0.05))
            : null, // Subtle scale border in dark mode
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
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        return child;
                      } else {
                        return const ShimmerLoading(width: 90, height: 130);
                      }
                    },
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Playfair Display',
                          fontSize: 16,
                          color: theme.colorScheme.onSurface, // Adaptive color
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      /// Auteur
                      Text(
                        book.author,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          color: theme
                              .textTheme.bodyMedium?.color, // Adaptive color
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Genre tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? theme.colorScheme.primary.withValues(alpha: 0.2)
                              : Colors.deepPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          book.genre,
                          style: TextStyle(
                            color: isDarkMode
                                ? theme.colorScheme.primary
                                : Colors.deepPurple,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LikeButton(
                        isFavorite: isFavorite,
                        onTap: () {
                          favoritesProvider.toggleFavorite(book);
                        },
                      ),
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
