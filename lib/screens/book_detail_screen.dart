// lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/history_provider.dart';
import '../theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();

    // Ajouter le livre à l'historique dès l'ouverture
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);
    historyProvider.addToHistory(widget.book);
  }

  /// Met à jour le temps de lecture
  Future<void> _updateReadingTime() async {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    final minutes = duration.inSeconds / 60;

    if (minutes > 0.1) { // ignore les lectures ultra rapides (<6 sec)
      final historyProvider =
          Provider.of<HistoryProvider>(context, listen: false);
      await historyProvider.updateBookTime(widget.book, minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageHeight = (MediaQuery.of(context).size.height * 0.32).clamp(200.0, 320.0);

    return WillPopScope(
      onWillPop: () async {
        // Met à jour le temps avant de quitter
        await _updateReadingTime();
        return true; // autorise la fermeture de la page
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: AppTheme.backgroundGradient(context),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: Image.asset(
                        book.imagePath,
                        width: double.infinity,
                        height: imageHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.author,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.genre,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      book.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
