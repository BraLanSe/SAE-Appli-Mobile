import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';

import '../utils/data.dart';
import '../screens/book_detail_screen.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/fade_in_animation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple logic to pick "recommended" books (e.g., first 5 or random)
    // In a real app, this would come from a recommendation engine.
    final List<Book> recommendedBooks = allBooks.take(5).toList();
    final List<Book> recentBooks = allBooks.skip(5).take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookwise",
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        // backgroundColor: Colors.deepPurple, // Removed to use Theme
        automaticallyImplyLeading: false, // Hide back button if any
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                "Recommandé pour vous",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Horizontal Carousel
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: recommendedBooks.length,
                itemBuilder: (context, index) {
                  final book = recommendedBooks[index];
                  return FadeInAnimation(
                    delay: index * 2,
                    child: _buildHorizontalBookCard(context, book),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: FadeInAnimation(
                delay: 2,
                child: Text(
                  "Tendances actuelles",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Vertical list snippet (for variety)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentBooks.length,
              itemBuilder: (context, index) {
                final book = recentBooks[index];
                return FadeInAnimation(
                  delay: (index + 2) * 2, // Staggered delay
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        book.imagePath,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded || frame != null) {
                            return child;
                          } else {
                            return const ShimmerLoading(width: 50, height: 75);
                          }
                        },
                        errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey, width: 50, height: 75),
                      ),
                    ),
                    title: Text(book.title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(book.author),
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
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalBookCard(BuildContext context, Book book) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDarkMode
            ? Border.all(color: Colors.white.withValues(alpha: 0.05))
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Provider.of<HistoryProvider>(context, listen: false)
              .addToHistory(book);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(
                  book: book, heroTag: 'home_carousel_${book.id}'),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Hero(
                tag: 'home_carousel_${book.id}',
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    book.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        return child;
                      } else {
                        return const ShimmerLoading(
                            width: double.infinity, height: double.infinity);
                      }
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                      alignment: Alignment.center,
                      child:
                          const Icon(Icons.book, size: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
