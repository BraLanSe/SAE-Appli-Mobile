import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'utils/data.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du provider des favoris et chargement des données
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites(allBooks);

  // Initialisation du provider d'historique
  final historyProvider = HistoryProvider();
  await historyProvider.loadHistory();

  // Initialisation du thème
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => favoritesProvider),
        ChangeNotifierProvider(create: (_) => historyProvider),
        ChangeNotifierProvider(create: (_) => themeProvider),
      ],
      child: const BookwiseApp(),
    ),
  );
}

class BookwiseApp extends StatelessWidget {
  const BookwiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Bookwise',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.roboto().fontFamily,
            textTheme: GoogleFonts.robotoTextTheme().copyWith(
              displayLarge: GoogleFonts.playfairDisplay(),
              displayMedium: GoogleFonts.playfairDisplay(),
              displaySmall: GoogleFonts.playfairDisplay(),
              headlineLarge: GoogleFonts.playfairDisplay(),
              headlineMedium: GoogleFonts.playfairDisplay(),
              headlineSmall: GoogleFonts.playfairDisplay(),
              titleLarge: GoogleFonts.playfairDisplay(),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.roboto().fontFamily,
            scaffoldBackgroundColor: const Color(0xFF121212),
            textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
                .copyWith(
              displayLarge: GoogleFonts.playfairDisplay(),
              displayMedium: GoogleFonts.playfairDisplay(),
              displaySmall: GoogleFonts.playfairDisplay(),
              headlineLarge: GoogleFonts.playfairDisplay(),
              headlineMedium: GoogleFonts.playfairDisplay(),
              headlineSmall: GoogleFonts.playfairDisplay(),
              titleLarge: GoogleFonts.playfairDisplay(),
            ),
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
