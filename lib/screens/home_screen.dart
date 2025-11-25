import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../utils/data.dart';
import '../services/recommendation_service.dart';
import '../widgets/book_card.dart';
import '../providers/favorites_provider.dart';
import 'favorites_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 🔎 Recherche
  String _searchQuery = "";

  // 🎭 Filtres
  String? _selectedGenre = "All";
  String _selectedSort = "A-Z";

  // Genres disponibles
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

  RecommendationService? _recoService;

  @override
  void initState() {
    super.initState();
    _recoService = RecommendationService(allBooks);
  }

  // 🔎 Applique recherche + filtres + tri
  List<Book> get filteredBooks {
    List<Book> books = [...allBooks];

    // Filtre par genre
    if (_selectedGenre != "All") {
      books = books
          .where((b) => b.genre.toLowerCase() == _selectedGenre!.toLowerCase())
          .toList();
    }

    // Recherche
    if (_searchQuery.isNotEmpty) {
      books = books
          .where((b) => b.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
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
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookwise"),
        backgroundColor: Colors.deepPurple,
        actions: [
          // ❤️ Favoris
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => FavoritesScreen()),
              );
            },
          ),
          // 🕒 Historique
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // 🔎 Champ de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un livre...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),

            // 🎭 Filtres par genre
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
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                      ),
                      selectedColor: Colors.deepPurple,
                      onSelected: (_) {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // 🔽 Tri
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
                    setState(() {
                      _selectedSort = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 📚 Liste des livres
            Expanded(
              child: filteredBooks.isEmpty
                  ? const Center(
                      child: Text(
                        "Aucun livre trouvé",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
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
          ],
        ),
      ),
    );
  }
}
