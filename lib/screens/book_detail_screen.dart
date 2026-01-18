import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart'; // IMPORTANT
import '../theme/app_theme.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final String heroTag;

  const BookDetailScreen({super.key, required this.book, required this.heroTag});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    // Ajout historique
    Provider.of<HistoryProvider>(context, listen: false).addToHistory(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    // On écoute le FavoritesProvider pour savoir si CE livre est favori
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFav = favoritesProvider.isFavorite(widget.book.id);

    return WillPopScope(
      onWillPop: () async {
        _updateReadingTime();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // --- BOUTON J'AIME FONCTIONNEL ---
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
                size: 28,
              ),
              onPressed: () {
                // Appel de la méthode toggleFavorite
                favoritesProvider.toggleFavorite(widget.book);
                
                // Petit feedback visuel (SnackBar)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isFav ? "Retiré des favoris" : "Ajouté aux favoris"),
                    duration: const Duration(milliseconds: 800),
                    backgroundColor: AppTheme.primaryViolet,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grande image
              Hero(
                tag: widget.heroTag,
                child: Container(
                  height: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(widget.book.imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              
              // Infos Livre
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    const SizedBox(height: 8),
                    Text(widget.book.author, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _infoChip(widget.book.genre, Icons.category),
                        const SizedBox(width: 10),
                        _infoChip("${widget.book.durationMinutes} min", Icons.timer),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("Résumé", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      widget.book.description,
                      style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryViolet.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.primaryViolet),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppTheme.primaryViolet, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Future<void> _updateReadingTime() async {
    final minutes = DateTime.now().difference(_startTime).inSeconds / 60.0;
    if (minutes > 0.1) {
      Provider.of<HistoryProvider>(context, listen: false).updateBookTime(widget.book, minutes);
    }
  }
}