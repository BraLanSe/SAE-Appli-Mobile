import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../utils/data.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_loading.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final String heroTag;

  const BookDetailScreen(
      {super.key, required this.book, required this.heroTag});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final TextEditingController _noteController = TextEditingController();
  double _readingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadNote();
    _loadProgress();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    final note = prefs.getString('note_${widget.book.id}') ?? '';
    setState(() {
      _noteController.text = note;
    });
  }

  Future<void> _saveNote(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('note_${widget.book.id}', value);
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _readingProgress = prefs.getDouble('progress_${widget.book.id}') ?? 0.0;
    });
  }

  Future<void> _updateProgress(double value) async {
    setState(() {
      _readingProgress = value;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('progress_${widget.book.id}', value);
  }

  @override
  Widget build(BuildContext context) {
    final relatedBooks = allBooks
        .where((b) => b.genre == widget.book.genre && b.id != widget.book.id)
        .take(5)
        .toList();

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400.0,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // ignore: deprecated_member_use
                  Share.share(
                      'Découvre ce livre : "${widget.book.title}" de ${widget.book.author} sur BookWise !');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.book.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 10)],
                ),
              ),
              background: Hero(
                tag: widget.heroTag,
                child: Image.asset(
                  widget.book.imagePath,
                  fit: BoxFit.cover,
                  color: Colors.black
                      .withValues(alpha: 0.2), // Darken image slightly
                  colorBlendMode: BlendMode.darken,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) {
                      return child;
                    } else {
                      return const ShimmerLoading(
                          width: double.infinity, height: double.infinity);
                    }
                  },
                ),
              ),
            ),
            backgroundColor: Colors.deepPurple,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        widget.book.author,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.book.genre,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode
                            ? theme.colorScheme.primary
                            : Colors.deepPurple.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.book.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Call to action simulation
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Bonne lecture !")),
                        );
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text("Commencer la lecture"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reading Progress Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Progression",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Playfair Display',
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${(_readingProgress * 100).toInt()}%",
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 6,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 8),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 16),
                    ),
                    child: Slider(
                      value: _readingProgress,
                      onChanged: _updateProgress,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor:
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Personal Notes Section
                  const Text(
                    "Mes notes",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Playfair Display',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    maxLines: 4,
                    onChanged: _saveNote,
                    decoration: InputDecoration(
                      hintText: "Écrivez vos pensées sur ce livre...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Related Books Section
                  if (relatedBooks.isNotEmpty) ...[
                    const Text(
                      "Vous aimerez aussi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedBooks.length,
                        itemBuilder: (context, index) {
                          final relatedBook = relatedBooks[index];
                          return Container(
                            width: 140,
                            margin:
                                const EdgeInsets.only(right: 12, bottom: 12),
                            child: BookCard(
                              book: relatedBook,
                              heroTag: 'related_${relatedBook.id}',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
