// lib/screens/book_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/history_provider.dart';

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

    return WillPopScope(
      onWillPop: () async {
        // Met à jour le temps avant de quitter
        await _updateReadingTime();
        return true; // autorise la fermeture de la page
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(book.title),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: widget.heroTag,
                child: Image.asset(
                  book.imagePath,
                  width: double.infinity,
                  height: 250,
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
                style: const TextStyle(
                  fontSize: 18, 
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                book.genre,
                style: const TextStyle(
                  fontSize: 16, 
                  color: Colors.deepPurple,
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
    );
  }
}
