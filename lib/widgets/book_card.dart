// lib/widgets/book_card.dart
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final String heroTag;

  const BookCard({super.key, required this.book, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigation vers le détail (à conserver)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book, heroTag: heroTag)),
        );
      },
      child: Container(
        // Design "Carte Flottante" de la vidéo
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image qui prend 80% de la place
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  book.imagePath,
                  fit: BoxFit.cover,
                  // Gestion d'erreur si l'image manque
                  errorBuilder: (c, o, s) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.book, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            // Titre minimaliste en bas
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Center(
                  child: Text(
                    book.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}