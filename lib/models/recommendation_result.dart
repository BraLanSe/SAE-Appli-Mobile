import 'book.dart';

class RecommendationResult {
  final Book book;
  final double score;
  final int matchPercentage;
  String reason;

  RecommendationResult({
    required this.book,
    required this.score,
    required this.matchPercentage,
    required this.reason,
  });
}
