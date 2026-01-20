class Book {
  final String id;             
  final String title;
  final String author;
  final String genre;
  final String imagePath;
  final String description;

  final int? popularity;
  final DateTime? dateAdded;

  // --- Champs pour recommandations et historique ---
  int clicks;
  int favorites;
  double minutesRead;

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

  // --- Conversion pour SQLite ---
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'imagePath': imagePath,
      'description': description,
      'popularity': popularity,
      'dateAdded': dateAdded?.toIso8601String(),
      'clicks': clicks,
      'favorites': favorites,
      'minutesRead': minutesRead,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      imagePath: map['imagePath'],
      description: map['description'],
      popularity: map['popularity'],
      dateAdded: map['dateAdded'] != null ? DateTime.parse(map['dateAdded']) : null,
      clicks: map['clicks'] ?? 0,
      favorites: map['favorites'] ?? 0,
      minutesRead: (map['minutesRead'] ?? 0).toDouble(),
    );
  }

  double get score {
    return (1.2 * clicks) + (2.5 * favorites) + (0.8 * minutesRead);
  }
}
