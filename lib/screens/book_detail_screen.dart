// lib/screens/book_detail_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';
import 'questionnaire_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final String heroTag;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.heroTag,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late DateTime _startTime;
  final ScrollController _scrollController = ScrollController();
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Ajouter le livre à l'historique dès l'ouverture
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HistoryProvider>(context, listen: false)
          .addToHistory(widget.book);
    });
  }

  /// Met à jour le temps de lecture
  Future<void> _updateReadingTime() async {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    final minutes = duration.inSeconds / 60;

    if (minutes > 0.1) {
      if (!mounted) return;
      final historyProvider =
          Provider.of<HistoryProvider>(context, listen: false);
      await historyProvider.updateBookTime(widget.book, minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final theme = Theme.of(context);
    // Removed unused isDark

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _updateReadingTime();
        if (context.mounted) {
          setState(() => _canPop = true);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // --- IMMERSIVE APP BAR ---
            SliverAppBar(
              expandedHeight: 400,
              pinned: true,
              stretch: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: theme.textTheme.bodyMedium?.color),
                  onPressed: () {
                    _updateReadingTime();
                    Navigator.pop(context);
                  },
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Blurred Background Image
                    Image.asset(
                      book.imagePath,
                      fit: BoxFit.cover,
                    ),
                    // Blur Effect
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                    // Main Image with Hero
                    Center(
                      child: Hero(
                        tag: widget.heroTag,
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(book.imagePath),
                          ),
                        ),
                      ),
                    ),
                    // Gradient at bottom for smooth transition
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              theme.scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- CONTENT ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Author
                    Text(
                      book.title,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.author,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(
                            context, Icons.category_outlined, book.genre),
                        _buildStat(context, Icons.trending_up,
                            "${book.popularity ?? 0} pts"),
                        _buildStat(context, Icons.timer_outlined,
                            "${book.minutesRead.toStringAsFixed(0)} min"),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Description Title
                    Text(
                      "Synopsis",
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      book.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Bouton Questionnaire
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionnaireScreen(book: book),
                            ),
                          );
                        },
                        icon: const Icon(Icons.rate_review),
                        label: const Text("J'ai lu ce livre"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100), // Spacing for FAB
                  ],
                ),
              ),
            ),
          ],
        ),

        // Floating Action Button for Favorite
        floatingActionButton: Consumer<FavoritesProvider>(
          builder: (context, favorites, _) {
            final isFav = favorites.isFavorite(book.id);
            return FloatingActionButton.extended(
              onPressed: () => favorites.toggleFavorite(book),
              backgroundColor: theme.primaryColor,
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              label: Text(
                isFav ? "Favori" : "Ajouter",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
