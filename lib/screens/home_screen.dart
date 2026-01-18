import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/database_service.dart';
import '../widgets/book_card.dart';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';

// Imports des écrans fonctionnels
import 'favorites_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _db = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _loading = true;
  bool _isSearching = false;
  String _selectedGenre = "All";

  // Liste des genres basés sur ta BDD
  final List<String> _genres = ["All", "Fiction", "Sci-Fi", "Fantasy", "Philosophie", "Thriller"];

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
      _filteredBooks = books;
      _loading = false;
    });
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBooks = _books.where((book) {
        final matchesGenre = _selectedGenre == "All" || book.genre.toLowerCase() == _selectedGenre.toLowerCase();
        final matchesSearch = book.title.toLowerCase().contains(query) || book.author.toLowerCase().contains(query);
        return matchesGenre && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      
      // --- MENU LATÉRAL (DRAWER) FONCTIONNEL ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryViolet, AppTheme.secondaryViolet],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo BookWise (Tu peux remettre ton image asset ici)
                  const Icon(Icons.auto_stories, size: 50, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text("BookWise", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            // Ces liens fonctionnent et mènent vers tes écrans existants
            ListTile(
              leading: const Icon(Icons.favorite, color: AppTheme.primaryViolet),
              title: const Text('Mes Favoris'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppTheme.primaryViolet),
              title: const Text('Historique de lecture'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: AppTheme.primaryViolet),
              title: const Text('Statistiques'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen())),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Provider.of<ThemeProvider>(context).isDarkMode ? Icons.light_mode : Icons.dark_mode),
              title: Text(Provider.of<ThemeProvider>(context).isDarkMode ? 'Mode Clair' : 'Mode Sombre'),
              onTap: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (_) => _filterBooks(),
                decoration: const InputDecoration(
                  hintText: "Titre, auteur...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black87),
              )
            : const Text("Catalogue", style: TextStyle(fontWeight: FontWeight.bold)), // TITRE MODIFIÉ
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: AppTheme.primaryViolet),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _filterBooks();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // Filtres
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _genres.length,
              itemBuilder: (context, index) {
                final genre = _genres[index];
                final isSelected = _selectedGenre == genre;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedGenre = genre;
                        _filterBooks();
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: AppTheme.primaryViolet.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryViolet : Colors.black54,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: isSelected ? AppTheme.primaryViolet : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                  ),
                );
              },
            ),
          ),

          // Grille de livres
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filteredBooks.isEmpty
                    ? const Center(child: Text("Aucun livre trouvé."))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) {
                          return BookCard(book: _filteredBooks[index], heroTag: 'home_${_filteredBooks[index].id}');
                        },
                      ),
          ),
        ],
      ),
    );
  }
}