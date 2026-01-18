class Review {
  final String bookId;
  final double rating;
  final String pacing;
  final bool likedEnding;
  final String comment;
  final DateTime date;

  Review({
    required this.bookId,
    required this.rating,
    required this.pacing,
    required this.likedEnding,
    required this.comment,
    required this.date,
  });

  // Conversion pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'rating': rating,
      'pacing': pacing,
      'likedEnding': likedEnding ? 1 : 0,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      bookId: map['bookId'],
      rating: map['rating'],
      pacing: map['pacing'],
      likedEnding: map['likedEnding'] == 1,
      comment: map['comment'],
      date: DateTime.parse(map['date']),
    );
  }
}
