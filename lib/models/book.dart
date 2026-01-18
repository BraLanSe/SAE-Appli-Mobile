class Book {
  final String id;
  final String title;
  final String author;
  final String genre;
  final String imagePath;
  final String description;
  final int durationMinutes; // Nouveau : Temps de lecture estimé du livre
  final int? popularity;
  final DateTime? dateAdded;

  // --- Champs utilisateur (non stockés dans la table 'books' mais dans 'stats') ---
  int clicks;
  int favorites; // 0 ou 1 pour SQL
  double minutesRead; // Temps passé par l'utilisateur dessus

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.imagePath,
    required this.description,
    this.durationMinutes = 120, // Valeur par défaut
    this.popularity,
    this.dateAdded,
    this.clicks = 0,
    this.favorites = 0,
    this.minutesRead = 0.0,
  });

  // Convertir un Map (venant de la BDD) en objet Book
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'].toString(),
      title: map['title'],
      author: map['author'],
      genre: map['genre'],
      imagePath: map['imagePath'],
      description: map['description'],
      durationMinutes: map['durationMinutes'] ?? 120,
      popularity: map['popularity'],
      // Gestion des dates stockées en texte
      dateAdded: map['dateAdded'] != null ? DateTime.tryParse(map['dateAdded']) : null,
      clicks: map['clicks'] ?? 0,
      favorites: map['favorites'] ?? 0,
      minutesRead: (map['minutesRead'] ?? 0).toDouble(),
    );
  }

  // Convertir un objet Book en Map (pour l'insérer dans la BDD)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'genre': genre,
      'imagePath': imagePath,
      'description': description,
      'durationMinutes': durationMinutes,
      'popularity': popularity,
      'dateAdded': dateAdded?.toIso8601String(),
      'clicks': clicks,
      'favorites': favorites,
      'minutesRead': minutesRead,
    };
  }
}