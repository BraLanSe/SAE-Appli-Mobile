import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/data.dart';
import '../services/recommendation_engine.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';

class DeveloperModeScreen extends StatefulWidget {
  const DeveloperModeScreen({super.key});

  @override
  State<DeveloperModeScreen> createState() => _DeveloperModeScreenState();
}

class _DeveloperModeScreenState extends State<DeveloperModeScreen> {
  int _benchmarkResultMs = 0;
  bool _isBenchmarking = false;

  void _runBenchmark() async {
    setState(() {
      _isBenchmarking = true;
    });

    // Simulate heavy work / measure actual recommendation speed
    await Future.delayed(const Duration(milliseconds: 100)); // UI breadth

    final stopwatch = Stopwatch()..start();

    // Run recommendation engine 1000 times to get a meaningful average
    for (int i = 0; i < 1000; i++) {
      RecommendationEngine.compute(
        allBooks: allBooks,
        userHistory: [], // Worst case cold start
        userFavorites: [],
      );
    }

    stopwatch.stop();

    if (mounted) {
      setState(() {
        _benchmarkResultMs = stopwatch.elapsedMilliseconds;
        _isBenchmarking = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _runBenchmark();
  }

  @override
  Widget build(BuildContext context) {
    final history = Provider.of<HistoryProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Performances & Métriques",
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoCard(
            context,
            title: "Architecture Données",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow("Type", "In-Memory NoSQL", Colors.green),
                _buildMetricRow(
                    "Complexité Algorithmique", "O(N)", Colors.blue),
                _buildMetricRow("Objets suivis", "${allBooks.length}",
                    theme.colorScheme.onSurface),
                _buildMetricRow(
                    "Taille catalogue", "~8 KB", theme.colorScheme.onSurface),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: "Performance Algorithme",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Benchmark : 1000 cycles de recommandation"),
                const SizedBox(height: 8),
                _isBenchmarking
                    ? const LinearProgressIndicator()
                    : _buildMetricRow(
                        "Temps Total", "$_benchmarkResultMs ms", Colors.orange),
                if (!_isBenchmarking)
                  _buildMetricRow(
                      "Moyenne par appel",
                      "${(_benchmarkResultMs / 1000).toStringAsFixed(3)} ms",
                      Colors.green),
              ],
            ),
            action: TextButton.icon(
              onPressed: _runBenchmark,
              icon: const Icon(Icons.refresh),
              label: const Text("Relancer Benchmark"),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: "Consommation Ressources",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow(
                    "Impact Batterie", "Faible (Mode Passif)", Colors.green),
                _buildMetricRow(
                    "Appels Réseau", "0 (Mode Hors-Ligne)", Colors.green),
                _buildMetricRow("FPS UI", "60 (Estimé)", Colors.blue),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: "État Utilisateur (Session)",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow("Livres lus", "${history.history.length}",
                    theme.colorScheme.onSurface),
                _buildMetricRow("Favoris", "${favorites.favorites.length}",
                    theme.colorScheme.onSurface),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required String title, required Widget content, Widget? action}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                if (action != null) action,
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }
}
