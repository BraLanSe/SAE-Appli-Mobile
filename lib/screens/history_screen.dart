import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<bool?> _confirmDialog(BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = "Confirmer",
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(context);
    final historyBooks = historyProvider.history;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: "Vider l'historique",
            onPressed: () async {
              final confirmed = await _confirmDialog(
                context,
                title: "Vider l'historique",
                message: "Supprimer tout l'historique de lecture ?",
                confirmLabel: "Supprimer",
              );
              if (confirmed == true) {
                await historyProvider.clearHistory();
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.backgroundGradient(context),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1B24) : Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: historyBooks.isEmpty
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
                          tooltip: "Supprimer de l'historique",
                          onPressed: () async {
                            final confirmed = await _confirmDialog(
                              context,
                              title: "Supprimer",
                              message: "Retirer ce livre de l'historique ?",
                              confirmLabel: "Supprimer",
                            );
                            if (confirmed == true) {
                              await historyProvider.removeFromHistory(book.id);
                            }
                          },
                        ),
                        onTap: () {
                          // Ici tu peux garder la navigation vers BookDetailScreen si tu veux
                        },
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

