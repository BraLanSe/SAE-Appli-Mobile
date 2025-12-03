import 'package:flutter/material.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  final String heroTag;

  const BookDetailScreen({super.key, required this.book, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: heroTag,
                child: Image.asset(
                  book.imagePath,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.contain, // <-- Corrigé pour ne pas zoomer
                ),
              ),
              const SizedBox(height: 16),
              Text(
                book.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                book.author,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 8),
              Text(
                book.genre,
                style: const TextStyle(fontSize: 16, color: Colors.deepPurple),
              ),
              const SizedBox(height: 16),
              Text(
                book.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

