import '../models/book.dart';

class RecommendationService {
  final List<Book> _allBooks;

  RecommendationService(this._allBooks);

  List<Book> recommend({String? favoriteGenre}) {
    List<Book> books = _allBooks;
    if (favoriteGenre != null) {
      books = books.where((b) => b.genre == favoriteGenre).toList();
    }
    books.sort((a, b) => b.clicks.compareTo(a.clicks));
    return books;
  }
}
