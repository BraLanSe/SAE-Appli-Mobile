import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/favorites_provider.dart';
import 'providers/history_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/filter_provider.dart'; // Added
import 'providers/user_profile_provider.dart'; // Added
import 'providers/to_read_provider.dart'; // Added
import 'utils/data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du provider des favoris et chargement des données
  final favoritesProvider = FavoritesProvider();
  await favoritesProvider.loadFavorites(allBooks);

  // Initialisation du provider de profil
  final userProfileProvider = UserProfileProvider();
  await userProfileProvider.loadProfile();

  // Initialisation du provider d'historique (avec dépendance vers userProfile)
  final historyProvider = HistoryProvider(userProfileProvider);
  await historyProvider.loadHistory();

  // Initialisation du thème
  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  // Initialisation du filtre
  final filterProvider = FilterProvider();

  // Check onboarding status
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => favoritesProvider),
        ChangeNotifierProvider(create: (_) => historyProvider),
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => filterProvider),
        ChangeNotifierProvider(create: (_) => userProfileProvider),
        ChangeNotifierProvider(
            create: (_) => ToReadProvider()..loadToReadList(allBooks)),
      ],
      child: BookwiseApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class BookwiseApp extends StatelessWidget {
  final bool seenOnboarding;

  const BookwiseApp({
    super.key,
    required this.seenOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Bookwise',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: ThemeData(
            primarySwatch: Colors
                .deepPurple, // Changed to Deep Purple for "Violet Profond"
            scaffoldBackgroundColor:
                const Color(0xFFF8FAFC), // Off-white (Slate 50)
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
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepPurple,
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.roboto().fontFamily,
            scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
            canvasColor: const Color(0xFF1E293B), // Slate 800
            cardColor: const Color(0xFF1E293B), // Slate 800

            // Define a refined ColorScheme
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF7C4DFF), // Deep Purple Accent 200
              secondary: Color(0xFFE040FB), // Purple Accent 200
              surface: Color(0xFF1E293B),
              onSurface: Color(0xFFF1F5F9), // Slate 100
              error: Color(0xFFEF4444),
            ),

            // AppBar Theme
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF0F172A).withValues(alpha: 0.8),
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: GoogleFonts.playfairDisplay(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Bottom Navigation Bar Theme
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E2230),
              selectedItemColor: Color(0xFF7C4DFF), // Deep Purple Accent
              unselectedItemColor: Colors.grey,
            ),

            // Chip Theme
            chipTheme: ChipThemeData(
              backgroundColor: const Color(0xFF1E2230),
              labelStyle: const TextStyle(color: Colors.white70),
              secondarySelectedColor:
                  const Color(0xFF7C4DFF).withValues(alpha: 0.3),
              secondaryLabelStyle: const TextStyle(color: Color(0xFF7C4DFF)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),

            // Text Theme
            textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme)
                .copyWith(
                  displayLarge:
                      GoogleFonts.playfairDisplay(color: Colors.white),
                  displayMedium:
                      GoogleFonts.playfairDisplay(color: Colors.white),
                  displaySmall:
                      GoogleFonts.playfairDisplay(color: Colors.white),
                  headlineLarge:
                      GoogleFonts.playfairDisplay(color: Colors.white),
                  headlineMedium:
                      GoogleFonts.playfairDisplay(color: Colors.white),
                  headlineSmall:
                      GoogleFonts.playfairDisplay(color: Colors.white),
                  titleLarge: GoogleFonts.playfairDisplay(color: Colors.white),
                  titleMedium: TextStyle(color: Colors.grey[300]),
                  bodyLarge: TextStyle(color: Colors.grey[300]),
                  bodyMedium: TextStyle(color: Colors.grey[400]),
                )
                .apply(
                  bodyColor: Colors.grey[300],
                  displayColor: Colors.white,
                ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}
