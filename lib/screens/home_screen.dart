import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:math';

import '../widgets/book_card.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'recommended_screen.dart';
import 'stats_screen.dart';
import '../providers/books_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the provider logic
    final booksProvider = Provider.of<BooksProvider>(context);
    final theme = Theme.of(context);

    // Slogans aléatoires pour le marketing
    final slogans = [
      "Prêt pour l'aventure ?",
      "Votre prochaine évasion commence ici.",
      "Explorez des mondes infinis.",
      "Lisez, rêvez, vivez.",
    ];
    final randomSlogan = slogans[Random().nextInt(slogans.length)];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER MAGNIFIQUE ---
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bonjour, Lecteur",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            randomSlogan,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      // Actions rapides (Icônes)
                      Row(
                        children: [
                          _buildIconButton(context, Icons.bar_chart, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const StatsScreen()));
                          }),
                          const SizedBox(width: 8),
                          _buildIconButton(context, Icons.history, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HistoryScreen()));
                          }),
                          const SizedBox(width: 8),
                          _buildIconButton(context, Icons.favorite, () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const FavoritesScreen()));
                          }),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search Bar Flottante
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon:
                            Icon(Icons.search, color: theme.primaryColor),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                      onChanged: (value) => booksProvider.setSearchQuery(value),
                    ),
                  ),
                ],
              ),
            ),

            // --- RECOMMANDATION BUTTON ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RecommendationsScreen()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Recommandations sur mesure",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // --- CATEGORIES (CHIPS) ---
            SizedBox(
              height: 50,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: booksProvider.genres.map((genre) {
                  final isSelected = booksProvider.selectedGenre == genre;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: FilterChip(
                        label: Text(genre),
                        selected: isSelected,
                        onSelected: (_) => booksProvider.setGenre(genre),
                        backgroundColor: theme.cardColor,
                        selectedColor: theme.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.textTheme.bodyMedium?.color,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.all(8),
                        side: BorderSide.none,
                        elevation: isSelected ? 4 : 0,
                        shadowColor: theme.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // --- LISTE ANIMÉE ---
            Expanded(
              child: booksProvider.filteredBooks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text("Aucun livre trouvé",
                              style: theme.textTheme.titleMedium),
                        ],
                      ),
                    )
                  : AnimationLimiter(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        physics: const BouncingScrollPhysics(),
                        itemCount: booksProvider.filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = booksProvider.filteredBooks[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: BookCard(book: book, heroTag: book.id),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onTap,
        color: Theme.of(context).textTheme.bodyMedium?.color,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
