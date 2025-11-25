// lib/models/book.dart
class Book {
  final String id;           // ID unique pour Hero et identification
  final String title;
  final String author;
  final String genre;
  final String imagePath;
  final String description;  // Description du livre
  final int? popularity;     // Popularité optionnelle
  final DateTime? dateAdded; // Date d'ajout optionnelle
  int clicks;                // Nombre de clics pour recommandations

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.imagePath,
    required this.description,
    this.popularity,
    this.dateAdded,
    this.clicks = 0,         // valeur par défaut
  });
}
