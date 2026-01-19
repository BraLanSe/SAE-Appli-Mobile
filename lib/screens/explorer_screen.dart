import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book.dart';
import '../utils/data.dart';
import '../widgets/book_card.dart';
import 'package:provider/provider.dart';
import '../providers/filter_provider.dart';
import '../widgets/fade_in_animation.dart';

class ExplorerScreen extends StatefulWidget {
  const ExplorerScreen({super.key});

  @override
  State<ExplorerScreen> createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = "A-Z";

  @override
  void initState() {
    super.initState();
    // Sync text controller with provider if needed, or just let it stay empty initially
    // But since we want to keep search persistence, we might want to set it.
    // For now, let's keep it simple.
  }

  final List<String> genres = [
    "All",
    "Roman", // Added
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

  List<Book> _getFilteredBooks(String genre, String searchQuery) {
    List<Book> books = [...allBooks];

    // Filtrer par genre
    if (genre != "All") {
      books = books
          .where((b) => b.genre.toLowerCase().contains(genre.toLowerCase()))
          .toList();
    }

    // Filtrer par recherche
    if (searchQuery.isNotEmpty) {
      books = books
          .where(
              (b) => b.title.toLowerCase().contains(searchQuery.toLowerCase()))
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
    final filterProvider = Provider.of<FilterProvider>(context);
    final filteredBooks = _getFilteredBooks(
      filterProvider.selectedGenre,
      filterProvider.searchQuery,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Explorer",
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
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
                hintStyle: TextStyle(
                    color: Theme.of(context).hintColor), // Adaptive hint
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: Theme.of(context).cardColor, // Adaptive fill
              ),
              onChanged: (value) {
                filterProvider.setSearchQuery(value);
              },
            ),
            const SizedBox(height: 12),

            //  Filtres par genre
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: genres.map((genre) {
                  final bool selected = filterProvider.selectedGenre == genre;
                  final theme = Theme.of(context);
                  final isDarkMode = theme.brightness == Brightness.dark;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        genre,
                        style: TextStyle(
                            color: selected
                                ? (isDarkMode
                                    ? theme.colorScheme.primary
                                    : Colors.deepPurple)
                                : (isDarkMode
                                    ? Colors.white70
                                    : Colors.grey[600]),
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal),
                      ),
                      selected: selected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: selected
                              ? (isDarkMode
                                  ? theme.colorScheme.primary
                                  : Colors.deepPurple)
                              : (isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade300),
                        ),
                      ),
                      onSelected: (_) {
                        filterProvider.setGenre(genre);
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
                Text(
                  "Trier par : ",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedSort,
                  items: sortOptions
                      .map((sort) => DropdownMenuItem(
                            value: sort,
                            child: Text(
                              sort,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
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
                        return FadeInAnimation(
                          delay: index,
                          child: BookCard(
                            book: book,
                            heroTag: 'explorer_${book.id}',
                          ),
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
