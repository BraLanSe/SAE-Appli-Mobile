import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart'; // Added

import '../utils/data.dart';
import '../screens/book_detail_screen.dart';
import '../widgets/fade_in_animation.dart';
import '../providers/filter_provider.dart';
import '../services/recommendation_engine.dart'; // Added
import 'main_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine greeting based on time
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? "Bonjour"
        : hour < 18
            ? "Bonne après-midi"
            : "Bonsoir";

    // Data simulation
    final Book featuredBook = allBooks.isNotEmpty ? allBooks.last : allBooks[0];

    // Get real data from providers
    final historyProvider = Provider.of<HistoryProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    // Compute recommendations dynamically
    final List<Book> recommendedBooks = RecommendationEngine.compute(
      allBooks: allBooks,
      userHistory: historyProvider.history,
      userFavorites: favoritesProvider.favorites,
    );

    // Recent books remains as is (or could be trending)
    final List<Book> recentBooks = allBooks.skip(5).take(5).toList();

    // Stats
    final historyCount = historyProvider.history.length;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bookwise",
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              // Future: Profile or Notifications
            },
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & Stats Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Amateur de livres",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.menu_book_rounded,
                            color: theme.colorScheme.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "$historyCount Lus",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // Featured Book Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(
                          book: featuredBook, heroTag: 'featured_home'),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(featuredBook.imagePath),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.4),
                        BlendMode.darken,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Livre du moment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          featuredBook.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          featuredBook.author,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Categories
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip(context, "Tous", true),
                  _buildCategoryChip(context, "Roman", false),
                  _buildCategoryChip(context, "Fantasy", false),
                  _buildCategoryChip(context, "Thriller", false),
                  _buildCategoryChip(context, "Sci-Fi", false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recommended Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommandé",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<FilterProvider>(context, listen: false)
                          .setGenre("All");
                      MainScreen.switchToTab(context, 1);
                    },
                    child: const Text("Voir tout"),
                  ),
                ],
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

            // Trending Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Text(
                "Tendances",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),

            // Vertical list snippet
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: recentBooks.length,
              itemBuilder: (context, index) {
                final book = recentBooks[index];
                return FadeInAnimation(
                  delay: (index + 2) * 2,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: isDarkMode
                          ? Border.all(
                              color: Colors.white.withValues(alpha: 0.05))
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
                          errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey, width: 50, height: 75),
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
                                book: book,
                                heroTag: 'home_vertical_${book.id}'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isActive) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isActive ? theme.colorScheme.primary : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final provider =
                Provider.of<FilterProvider>(context, listen: false);
            provider.setGenre(label == "Tous" ? "All" : label);
            MainScreen.switchToTab(context, 1);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: isActive
                  ? null
                  : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : (isDarkMode ? Colors.white70 : Colors.grey[700]),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalBookCard(BuildContext context, Book book) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      width: 150, // Slightly simpler width
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: InkWell(
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
            Hero(
              tag: 'home_carousel_${book.id}',
              child: Container(
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
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
