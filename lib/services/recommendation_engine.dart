import 'dart:math';
import 'package:flutter/foundation.dart'; // Added for debugPrint
import '../models/book.dart';
import '../models/recommendation_result.dart';
import 'database_service.dart';
import '../utils/performance_monitor.dart';

class RecommendationEngine {
  /// Computes a list of recommended books based on user history and favorites from SQLite.
  /// Uses PerformanceMonitor to log execution time.
  static Future<List<RecommendationResult>> compute({
    required List<Book> allBooks,
    int limit = 5,
  }) async {
    final monitor = PerformanceMonitor();

    // 1. Initialisation & Battery Check
    await monitor.logBatteryStats();
    final int batteryLevel = await monitor.getBatteryLevel();
    final bool isEcoMode = batteryLevel < 20;

    debugPrint(
        "[BATTERY_MODE] ${isEcoMode ? "Eco (Level: $batteryLevel%)" : "Full (Level: $batteryLevel%)"}");

    return await monitor.measureAsync<List<RecommendationResult>>(
      "Recommendation Algorithm (${isEcoMode ? 'Simple' : 'Jaccard'})",
      () async {
        final dbService = DatabaseService();

        // 2. Fetch User Context
        // Pour Jaccard, on a besoin des livres complets (historique + favoris)
        // Le DatabaseService retourne les IDs sous forme de List<String>
        final favoriteIds = await dbService.getFavorites();
        final historyIds = await dbService.getHistory();

        // On combine pour avoir le "Profil Utilisateur" (les 5 derniers)
        final uniqueUserBookIds = {...favoriteIds, ...historyIds}.toList();

        // Map IDs to Book objects
        final userBooks = allBooks
            .where((b) => uniqueUserBookIds.contains(b.id))
            .take(5) // On garde les 5 plus récents/pertinents
            .toList();

        List<RecommendationResult> results = [];

        // 3. Branching Logic
        if (isEcoMode) {
          // --- MODE ÉCO : Algorithme Simple (Top Genres) ---
          final preferredGenres = await dbService.getPreferredGenres();
          final random = Random();

          // Analyse limitée à 50 livres max pour économiser le CPU
          final analysisScope = allBooks.take(50).toList();

          if (preferredGenres.isNotEmpty) {
            final candidateBooks = analysisScope
                .where((b) =>
                    preferredGenres.contains(b.genre) &&
                    !uniqueUserBookIds.contains(b.id))
                .toList();

            candidateBooks.shuffle(random);

            for (var book in candidateBooks.take(limit)) {
              results.add(RecommendationResult(
                book: book,
                score: 5.0, // Score statique
                matchPercentage: 80 + random.nextInt(10),
                reason: "Mode Éco : Genre ${book.genre}",
              ));
            }
          }
        } else {
          // --- MODE FULL : Algorithme Jaccard (Vectoriel) ---

          if (userBooks.isEmpty) {
            // Fallback Cold Start si aucun historique même en mode Full
            // On utilise la popularité sur tout le catalogue
          } else {
            // Pour chaque livre du catalogue (qui n'est pas déjà lu/aimé)
            for (var candidate in allBooks) {
              if (uniqueUserBookIds.contains(candidate.id)) continue;

              double totalSim = 0;
              for (var refBook in userBooks) {
                totalSim += _calculateJaccardIndex(candidate, refBook);
              }
              double avgSim = totalSim / userBooks.length;

              // On ne garde que ceux qui ont une similarité minimale (ex: > 0.1)
              if (avgSim > 0.1) {
                results.add(RecommendationResult(
                  book: candidate,
                  score: avgSim * 10, // Scale to roughly 0-10
                  matchPercentage: (avgSim * 100).round().clamp(0, 100),
                  reason:
                      "Similaire à '${userBooks.first.title}'...", // Simplification de la raison
                ));
              }
            }

            // Dédoublonnage et Tri par score décroissant
            results.sort((a, b) => b.score.compareTo(a.score));
            results = results.take(limit).toList();

            // Raffinage de la "Raison" (Prendre le livre de ref le plus proche)
            for (var result in results) {
              // Retrouver le livre de ref le plus proche
              Book? bestRef;
              double bestSim = -1;
              for (var ref in userBooks) {
                double sim = _calculateJaccardIndex(result.book, ref);
                if (sim > bestSim) {
                  bestSim = sim;
                  bestRef = ref;
                }
              }
              if (bestRef != null) {
                result.reason =
                    "Similaire à ${bestRef.title} (${(bestSim * 100).round()}%)";
              }
            }
          }
        }

        // 4. Fill with Popular (Fallback commun)
        if (results.length < limit) {
          final existingIds = results.map((r) => r.book.id).toSet();
          existingIds
              .addAll(uniqueUserBookIds); // Ne pas recommander ce qu'on a déjà

          final fallbackBooks = allBooks
              .where((b) => !existingIds.contains(b.id))
              .toList()
            ..sort((a, b) => (b.popularity ?? 0).compareTo(a.popularity ?? 0));

          for (var book in fallbackBooks.take(limit - results.length)) {
            results.add(RecommendationResult(
              book: book,
              score: isEcoMode ? 1.0 : 0.5,
              matchPercentage: isEcoMode ? 60 : 40,
              reason:
                  isEcoMode ? "Mode Éco : Populaire" : "Découverte (Populaire)",
            ));
          }
        }

        return results;
      },
    );
  }

  /// Calcule l'indice de Jaccard entre deux livres.
  /// Considère (Titre Mots-clés + Genre + Auteur) comme un ensemble (Bag of Words).
  static double _calculateJaccardIndex(Book a, Book b) {
    Set<String> getTags(Book book) {
      final tags = <String>{};

      // 1. Genre (Fort poids, on pourrait le mettre en MAJUSCULE pour unicité)
      tags.add("GENRE:${book.genre.toUpperCase()}");

      // 2. Auteur
      tags.add("AUTHOR:${book.author.toUpperCase()}");

      // 3. Mots du titre (Tokens > 3 lettres)
      final titleWords = book.title
          .toLowerCase()
          .split(RegExp(r'\s+'))
          .where((w) => w.length > 3)
          .map((w) => "WORD:$w");
      tags.addAll(titleWords);

      // (Optionnel) Ajout de description keywords si on voulait faire du "Deep Content Based"

      return tags;
    }

    final setA = getTags(a);
    final setB = getTags(b);

    final intersection = setA.intersection(setB).length;
    final union = setA.union(setB).length;

    if (union == 0) return 0.0;

    return intersection / union;
  }
}
