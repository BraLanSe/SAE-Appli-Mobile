import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/recommendation_result.dart';
import '../../providers/history_provider.dart';
import '../../screens/book_detail_screen.dart';
import '../fade_in_animation.dart';

class RecommendedCarousel extends StatelessWidget {
  final List<RecommendationResult> recommendedResults;

  const RecommendedCarousel({super.key, required this.recommendedResults});

  @override
  Widget build(BuildContext context) {
    if (recommendedResults.isEmpty) {
      return const SizedBox(height: 0);
    }

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: recommendedResults.length,
        itemBuilder: (context, index) {
          final result = recommendedResults[index];
          return FadeInAnimation(
            delay: index * 2,
            child: _buildHorizontalBookCard(context, result),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalBookCard(
      BuildContext context, RecommendationResult result) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final book = result.book;

    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
        onTap: () {
          Provider.of<HistoryProvider>(context, listen: false)
              .addToHistory(book);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(
                book: book,
                heroTag: 'home_carousel_${book.id}',
                matchPercentage: result.matchPercentage,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'home_carousel_${book.id}',
              child: Stack(
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
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
                      image: DecorationImage(
                        image: AssetImage(book.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (result.matchPercentage > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          border: isDarkMode
                              ? Border.all(color: Colors.white24, width: 1.5)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                        child: Text(
                          "${result.matchPercentage}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              result.reason,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
