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
    // ✅ Changement ici : on passe l'ID au lieu de l'objet
    final bool isFavorite = favoritesProvider.isFavorite(book.id);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
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
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Image.asset(
                  book.imagePath,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.book, size: 40, color: Colors.white),
                  ),
                ),
              ),
            ),

            /// ---- TEXTE ----
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Titre
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    /// Auteur
                    Text(
                      book.author,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),

                    /// Genre
                    Text(
                      book.genre,
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ---- FAVORIS ----
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(book);
                  },
                ),

                /// Affichage du compteur "favorites"
                if (book.favorites > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${book.favorites} ❤',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
