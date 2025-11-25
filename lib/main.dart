import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'utils/data.dart';
import 'screens/home_screen.dart'; 
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
      // Choisis ici quel écran afficher au lancement
      home: const WelcomeScreen(), // ← l'écran de bienvenue sera affiché au lancement
      // Si tu veux tester directement HomeScreen, remplace par :
      // home: const HomeScreen(),
    );
  }
}
