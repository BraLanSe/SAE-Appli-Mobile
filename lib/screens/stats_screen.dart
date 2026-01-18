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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistiques"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _statTile(
              icon: Icons.timer,
              title: "Temps total de lecture",
              value: "${totalMinutes.toStringAsFixed(1)} min",
            ),
            _statTile(
              icon: Icons.schedule,
              title: "Temps moyen par livre",
              value: "${avgMinutes.toStringAsFixed(1)} min",
            ),
            _statTile(
              icon: Icons.category,
              title: "Genre préféré",
              value: favoriteGenre,
            ),
            _statTile(
              icon: Icons.favorite,
              title: "Nombre de favoris",
              value: favorites.length.toString(),
            ),
            _statTile(
              icon: Icons.history,
              title: "Livres consultés",
              value: history.length.toString(),
            ),
            _statTile(
              icon: Icons.memory,
              title: "Livres en mémoire",
              value: (history.length + favorites.length).toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
