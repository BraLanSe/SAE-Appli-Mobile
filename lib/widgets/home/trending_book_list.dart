import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/book.dart';
import '../../providers/history_provider.dart';
import '../../screens/book_detail_screen.dart';
import '../fade_in_animation.dart';

class TrendingBookList extends StatelessWidget {
  final List<Book> books;

  const TrendingBookList({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return FadeInAnimation(
          delay: (index + 2) * 2,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isDarkMode
                  ? Border.all(color: Colors.white.withValues(alpha: 0.05))
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  book.imagePath,
                  width: 50,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey, width: 50, height: 75),
                ),
              ),
              title: Text(
                book.title,
                style: GoogleFonts.playfairDisplay(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                book.author,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              trailing: Icon(Icons.chevron_right_rounded,
                  color: theme.colorScheme.primary),
              onTap: () {
                Provider.of<HistoryProvider>(context, listen: false)
                    .addToHistory(book);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailScreen(
                        book: book, heroTag: 'home_vertical_${book.id}'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
