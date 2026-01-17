import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: const WelcomeScreen(),
    );
  }
}
