// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';
import '../widgets/book_card.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'recommended_screen.dart';
import 'stats_screen.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final DatabaseService _db = DatabaseService();

  List<Book> _books = [];
  bool _loading = true;

  String _searchQuery = "";
  String? _selectedGenre = "All";
  String _selectedSort = "A-Z";

  final List<String> genres = [
    "All",
    "Fiction",
    "Science-Fiction",
    "Fantasy",
    "Roman Philosophique",
    "Classique",
    "Horreur",
    "Romance",
    "Poésie",
    "Thriller Psychologique",
    "Cyberpunk",
    "Satire",
    "Drame",
  ];

  final List<String> sortOptions = [
    "A-Z",
    "Z-A",
    "Plus populaire",
    "Date ajout",
  ];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await _db.getAllBooks();
    if (!mounted) return;
    setState(() {
      _books = books;
      _loading = false;
    });
  }

  List<Book> get filteredBooks {
    List<Book> books = [..._books];

    // Filtrer par genre
    if (_selectedGenre != "All") {
      books = books
          .where((b) => b.genre.toLowerCase() == _selectedGenre!.toLowerCase())
          .toList();
    }

    // Filtrer par recherche : titre OU auteur
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      books = books.where((b) =>
          b.title.toLowerCase().contains(queryLower) ||
          b.author.toLowerCase().contains(queryLower)
      ).toList();
    }

    // Tri
    switch (_selectedSort) {
      case "A-Z":
        books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Z-A":
        books.sort((a, b) => b.title.compareTo(a.title));
        break;
      case "Plus populaire":
        books.sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));
        break;
      case "Date ajout":
        books.sort((a, b) =>
            (b.dateAdded ?? DateTime(2000)).compareTo(a.dateAdded ?? DateTime(2000)));
        break;
    }

    return books;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookwise"),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ThemeProvider>(context).isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: "Mode sombre",
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: "Favoris",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Historique",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: "Statistiques",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barre de recherche
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Rechercher un livre ou un auteur...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 12),

                // Bouton vers recommandations
                ElevatedButton.icon(
                  icon: const Icon(Icons.star, color: Colors.white),
                  label: const Text(
                    "Voir recommandations",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RecommendationsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Filtres par genre
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: genres.map((genre) {
                      final bool selected = _selectedGenre == genre;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(genre),
                          selected: selected,
                          selectedColor: Colors.deepPurple,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() => _selectedGenre = genre);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Tri
                Row(
                  children: [
                    const Text(
                      "Trier par : ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: _selectedSort,
                      items: sortOptions
                          .map((sort) => DropdownMenuItem(
                                value: sort,
                                child: Text(sort),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedSort = value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Liste des livres
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredBooks.isEmpty
                          ? const Center(
                              child: Text(
                                "Aucun livre trouvé",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadBooks,
                              child: ListView.builder(
                                itemCount: filteredBooks.length,
                                itemBuilder: (context, index) {
                                  final book = filteredBooks[index];
                                  return BookCard(
                                    book: book,
                                    heroTag: book.id,
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
