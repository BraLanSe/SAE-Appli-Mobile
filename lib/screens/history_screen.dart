import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../widgets/book_card.dart';
import 'main_screen.dart';

import '../widgets/fade_in_animation.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final historyBooks = historyProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        // backgroundColor: Colors.deepPurple, // Removed to use theme
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Vider l'historique",
            onPressed: () => historyProvider.clearHistory(),
          ),
        ],
      ),
      body: historyBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history,
                      size: 80,
                      color: Colors.deepPurple.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text(
                    "Aucun historique",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display',
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Les livres que vous consultez\napparaîtront ici.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      MainScreen.switchToTab(context, 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Découvrir des livres"),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(
                  vertical: 8, horizontal: 0), // Card has margin
              itemCount: historyBooks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final book = historyBooks[index];
                return FadeInAnimation(
                  delay: index,
                  child: BookCard(book: book, heroTag: 'hist_${book.id}'),
                );
              },
            ),
    );
  }
}
