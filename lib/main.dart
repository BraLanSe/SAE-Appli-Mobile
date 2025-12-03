import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'utils/data.dart';
import 'screens/welcome_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du provider des favoris et chargement des données
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites(allBooks);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => favoritesProvider),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
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
