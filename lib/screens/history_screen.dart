import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final historyBooks = historyProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Vider l'historique",
            onPressed: () => historyProvider.clearHistory(),
          ),
        ],
      ),
      body: historyBooks.isEmpty
          ? const Center(
              child: Text(
                "Aucun livre consulté",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: historyBooks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final book = historyBooks[index];
                return ListTile(
                  leading: Image.asset(
                    book.imagePath,
                    width: 50,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Supprimer du l'historique",
                    onPressed: () => historyProvider.removeFromHistory(book.id),
                  ),
                  onTap: () {
                    // Ici tu peux garder la navigation vers BookDetailScreen si tu veux
                  },
                );
              },
            ),
    );
  }
}

