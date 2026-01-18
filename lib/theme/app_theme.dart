import 'package:flutter/material.dart';

class AppTheme {
  // Codes couleurs basés sur ton rapport "BookWise"
  static const Color primaryViolet = Color(0xFF6A1B9A); // Un violet profond et "sage"
  static const Color secondaryViolet = Color(0xFF9C27B0); // Plus clair pour les accents
  static const Color backgroundWhite = Color(0xFFF5F5F7); // Blanc cassé apaisant pour les yeux
  static const Color textDark = Color(0xFF2D2D2D);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundWhite, // Fond clair comme demandé
    primaryColor: primaryViolet,
    
    // Barre d'app Violette (Identité forte)
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent, // Moderne
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat', // Police propre
      ),
    ),

    // Boutons violets
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    
    // Chips (filtres)
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: primaryViolet,
      labelStyle: TextStyle(color: textDark),
      secondaryLabelStyle: TextStyle(color: Colors.white),
    ),
  );
 
 static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF121212),
      primaryColor: primaryViolet,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryViolet,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFF2D2D2D),
        selectedColor: primaryViolet,
        labelStyle: const TextStyle(color: Colors.white),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}