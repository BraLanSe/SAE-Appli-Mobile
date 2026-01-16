import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../utils/data.dart';
import '../widgets/book_card.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final TextEditingController _searchController = TextEditingController();

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

  List<Book> get filteredBooks {
    List<Book> books = [...allBooks];

    // Filtrer par genre
    if (_selectedGenre != "All") {
      books = books
          .where((b) => b.genre.toLowerCase() == _selectedGenre!.toLowerCase())
          .toList();
    }

    // Filtrer par recherche
    if (_searchQuery.isNotEmpty) {
      books = books
          .where(
              (b) => b.title.toLowerCase().contains(_searchQuery.toLowerCase()))
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
        books.sort((a, b) => (b.dateAdded ?? DateTime(2000))
            .compareTo(a.dateAdded ?? DateTime(2000)));
        break;
    }

    return books;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Explorer",
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            //  Champ de recherche
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un livre...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
            const SizedBox(height: 12),

            //  Filtres par genre
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
                      selectedColor: Colors.deepPurple.shade100,
                      labelStyle: TextStyle(
                        color: selected ? Colors.deepPurple : Colors.black,
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selected
                              ? Colors.deepPurple
                              : Colors.grey.shade300,
                        ),
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

            //  Tri
            Row(
              children: [
                const Text(
                  "Trier par : ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedSort,
                  items: sortOptions
                      .map((sort) => DropdownMenuItem(
                            value: sort,
                            child: Text(sort,
                                style: const TextStyle(fontSize: 14)),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedSort = value!);
                  },
                  underline:
                      Container(), // Remove default underline for cleaner look
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Liste complète des livres
            Expanded(
              child: filteredBooks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            "Aucun livre trouvé",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        return BookCard(
                          book: book,
                          heroTag: 'explorer_${book.id}',
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
