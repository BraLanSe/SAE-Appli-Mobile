// lib/screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final history = historyProvider.history;
    final favorites = favoritesProvider.favorites;

    // Temps total et moyen de lecture
    final totalMinutes = history.fold<double>(
      0,
      (sum, book) => sum + book.minutesRead,
    );

    final avgMinutes = history.isEmpty
        ? 0
        : totalMinutes / history.length;

    // Genre préféré
    final Map<String, int> genreCounts = {};
    for (var book in history) {
      genreCounts[book.genre] = (genreCounts[book.genre] ?? 0) + 1;
    }

    final favoriteGenre = genreCounts.isEmpty
        ? "Aucun"
        : genreCounts.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

    // Top 3 genres
    final sortedGenres = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topGenres = sortedGenres.take(3).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Mes Statistiques",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec résumé
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat(
                        icon: Icons.auto_stories,
                        value: history.length.toString(),
                        label: "Consultés",
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildHeaderStat(
                        icon: Icons.favorite,
                        value: favorites.length.toString(),
                        label: "Favoris",
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildHeaderStat(
                        icon: Icons.timer,
                        value: "${totalMinutes.toStringAsFixed(0)}",
                        label: "Minutes",
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grille de statistiques principales
            const Text(
              "Vue d'ensemble",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard(
                  context: context,
                  icon: Icons.schedule,
                  title: "Temps moyen",
                  value: "${avgMinutes.toStringAsFixed(1)} min",
                  color: const Color(0xFF667EEA),
                  lightColor: const Color(0xFFE0E7FF),
                ),
                _buildStatCard(
                  context: context,
                  icon: Icons.category,
                  title: "Genre préféré",
                  value: favoriteGenre,
                  color: const Color(0xFFEC4899),
                  lightColor: const Color(0xFFFCE7F3),
                ),
                _buildStatCard(
                  context: context,
                  icon: Icons.library_books,
                  title: "Total livres",
                  value: (history.length + favorites.length).toString(),
                  color: const Color(0xFF10B981),
                  lightColor: const Color(0xFFD1FAE5),
                ),
                _buildStatCard(
                  context: context,
                  icon: Icons.trending_up,
                  title: "Genres explorés",
                  value: genreCounts.length.toString(),
                  color: const Color(0xFFF59E0B),
                  lightColor: const Color(0xFFFEF3C7),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Top 3 Genres
            if (topGenres.isNotEmpty) ...[
              const Text(
                "Top Genres",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              ...topGenres.asMap().entries.map((entry) {
                final index = entry.key;
                final genre = entry.value;
                final maxCount = topGenres.first.value;
                final percentage = (genre.value / maxCount);
                
                final colors = [
                  const Color(0xFF667EEA),
                  const Color(0xFFEC4899),
                  const Color(0xFF10B981),
                ];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildGenreBar(
                    genre: genre.key,
                    count: genre.value,
                    percentage: percentage,
                    color: colors[index],
                    rank: index + 1,
                  ),
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color lightColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenreBar({
    required String genre,
    required int count,
    required double percentage,
    required Color color,
    required int rank,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "$rank",
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    genre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
              Text(
                "$count livres",
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
