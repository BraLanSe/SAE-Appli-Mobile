import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/history_provider.dart';
import '../screens/book_detail_screen.dart'; // Pour la navigation

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final historyBooks = historyProvider.history;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Historique de Lecture",
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: "Vider l'historique",
            onPressed: () => _confirmClear(context, historyProvider),
          ),
        ],
      ),
      body: historyBooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off,
                      size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "Chaque lecture est un voyage.",
                    style: theme.textTheme.titleMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            )
          : AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: historyBooks.length,
                itemBuilder: (context, index) {
                  final book = historyBooks[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
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
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Hero(
                              tag: "hist_${book.id}",
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  book.imagePath,
                                  width: 50,
                                  height: 75,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(book.title,
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontSize: 16)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(book.author,
                                    style: theme.textTheme.bodyMedium),
                                Text(
                                  "Lu pendant ${book.minutesRead.toStringAsFixed(0)} min",
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.grey, size: 20),
                              onPressed: () =>
                                  historyProvider.removeFromHistory(book.id),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BookDetailScreen(
                                          book: book,
                                          heroTag: "hist_${book.id}")));
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _confirmClear(BuildContext context, HistoryProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Effacer l'historique ?"),
        content: const Text("Cette action est irréversible."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              provider.clearHistory();
              Navigator.pop(ctx);
            },
            child: const Text("Effacer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
