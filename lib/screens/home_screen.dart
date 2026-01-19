import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';

import '../utils/data.dart';
// import '../screens/book_detail_screen.dart'; // No longer needed
// import '../widgets/fade_in_animation.dart'; // No longer needed directly here
import '../providers/filter_provider.dart';
import '../services/recommendation_engine.dart';
import '../models/recommendation_result.dart';
import 'main_screen.dart';
import 'profile_screen.dart';

// Import new widgets
import '../widgets/home/featured_book_banner.dart';
import '../widgets/home/category_filter_list.dart';
import '../widgets/home/recommended_carousel.dart';
import '../widgets/home/trending_book_list.dart';

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
    // final favoritesProvider = Provider.of<FavoritesProvider>(context); // Unused

    // Recent books remains as is (or could be trending)
    final List<Book> recentBooks = allBooks.skip(5).take(5).toList();

    // Stats
    final historyCount = historyProvider.history.length;

    final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark; // Unused here now

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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_rounded),
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
            FeaturedBookBanner(featuredBook: featuredBook),

            const SizedBox(height: 24),

            // Quick Categories
            const CategoryFilterList(),

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

            // Horizontal Carousel with FutureBuilder
            FutureBuilder<List<RecommendationResult>>(
              future: RecommendationEngine.compute(allBooks: allBooks),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 320,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return const SizedBox(
                    height: 320,
                    child: Center(child: Text("Erreur de chargement")),
                  );
                }

                final results = snapshot.data ?? [];
                return RecommendedCarousel(recommendedResults: results);
              },
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
            TrendingBookList(books: recentBooks),

            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}
