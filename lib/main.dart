import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/books_provider.dart'; // Added
import 'utils/app_theme.dart'; // Added
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites();

  final historyProvider = HistoryProvider();
  await historyProvider.loadHistory();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => favoritesProvider),
        ChangeNotifierProvider(create: (_) => historyProvider),
        ChangeNotifierProvider(
            create: (_) => BooksProvider()), // Added BooksProvider
      ],
      child: const BookwiseApp(),
    ),
  );
}

class BookwiseApp extends StatelessWidget {
  const BookwiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookwise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Adapt to system preference
      home: const WelcomeScreen(),
    );
  }
}
