class Book {
  final String id;             
  final String title;
  final String author;
  final String genre;
  final String imagePath;
  final String description;

  final int? popularity;
  final DateTime? dateAdded;

  // --- Champs utilisés pour le système de recommandations ---
  int clicks;            // nombre de fois que le livre a été ouvert
  int favorites;         // nombre de fois ajouté aux favoris
  double minutesRead;    // temps passé à lire le livre

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.imagePath,
    required this.description,
    this.popularity,
    this.dateAdded,
    this.clicks = 0,
    this.favorites = 0,
    this.minutesRead = 0,
  });

  /// Score de recommandation automatique
  double get score {
    return (1.2 * clicks) + (2.5 * favorites) + (0.8 * minutesRead);
  }
}
