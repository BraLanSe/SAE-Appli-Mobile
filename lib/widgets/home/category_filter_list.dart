import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/filter_provider.dart';
import '../../screens/main_screen.dart';

class CategoryFilterList extends StatelessWidget {
  const CategoryFilterList({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste des genres pour les filtres
    final categories = ["Tous", "Fiction", "Fantasy", "Thriller", "Sci-Fi"];

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((genre) {
          final filterProvider = Provider.of<FilterProvider>(context);
          bool isActive = false;

          // Logique de correspondance avec les données réelles
          if (genre == "Tous" && filterProvider.selectedGenre == "All") {
            isActive = true;
          } else if (genre == "Sci-Fi" &&
              filterProvider.selectedGenre == "Science-Fiction") {
            isActive = true;
          } else if (genre == "Thriller" &&
              filterProvider.selectedGenre == "Thriller Psychologique") {
            isActive = true;
          } else if (genre == filterProvider.selectedGenre) {
            isActive = true;
          }

          return _buildCategoryChip(context, genre, isActive);
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isActive) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: isActive ? theme.colorScheme.primary : theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final provider =
                Provider.of<FilterProvider>(context, listen: false);

            provider.setSearchQuery("");

            String value = label;
            if (label == "Tous") {
              value = "All";
            } else if (label == "Sci-Fi") {
              value = "Science-Fiction";
            } else if (label == "Thriller") {
              value = "Thriller Psychologique";
            }

            provider.setGenre(value);
            // On suppose que MainScreen est accessible, sinon il faudra passer via un callback ou une autre méthode de navigation
            try {
              MainScreen.switchToTab(context, 1); // 1 = Explore tab
            } catch (e) {
              // Fallback si on n'est pas dans le contexte ou si MainScreen n'est pas trouvé
              debugPrint("Impossible de changer d'onglet: $e");
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: isActive
                  ? null
                  : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.white
                    : (isDarkMode ? Colors.white : Colors.grey[700]),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
