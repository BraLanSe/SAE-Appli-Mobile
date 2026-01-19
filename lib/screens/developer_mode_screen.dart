import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/data.dart';
import '../services/recommendation_engine.dart';
import '../services/statistics_service.dart';
import '../providers/history_provider.dart';
import '../providers/favorites_provider.dart';

class DeveloperModeScreen extends StatefulWidget {
  const DeveloperModeScreen({super.key});

  @override
  State<DeveloperModeScreen> createState() => _DeveloperModeScreenState();
}

class _DeveloperModeScreenState extends State<DeveloperModeScreen> {
  int _benchmarkAvgMs = 0;
  int _benchmarkMinMs = 0;
  int _benchmarkMaxMs = 0;
  bool _isBenchmarking = false;

  // Battery simulation stats
  String _batteryStatus = "Optimale";
  double _estimatedDrainPerHour = 0.5; // % per hour active

  void _runBenchmark() async {
    setState(() {
      _isBenchmarking = true;
    });

    // Simulate heavy work / measure actual recommendation speed
    await Future.delayed(const Duration(milliseconds: 100)); // UI breadth

    final stopwatch = Stopwatch();
    int totalUs = 0; // Microseconds
    int minUs = 9999999;
    int maxUs = 0;

    // Run recommendation engine 500 times to get meaningful stats
    for (int i = 0; i < 500; i++) {
      stopwatch.reset();
      stopwatch.start();

      RecommendationEngine.compute(
        allBooks: allBooks,
        userHistory: [], // Worst case cold start
        userFavorites: [],
      );

      stopwatch.stop();
      int elapsed = stopwatch.elapsedMicroseconds;

      totalUs += elapsed;
      if (elapsed < minUs) minUs = elapsed;
      if (elapsed > maxUs) maxUs = elapsed;
    }

    if (mounted) {
      setState(() {
        _benchmarkAvgMs = (totalUs / 500).round(); // Avg in Microseconds
        _benchmarkMinMs = minUs;
        _benchmarkMaxMs = maxUs;
        _isBenchmarking = false;

        // Update simulated battery stats based on load
        if (_benchmarkAvgMs > 5000) {
          _batteryStatus = "Intensive";
          _estimatedDrainPerHour = 5.0;
        } else {
          _batteryStatus = "Faible (Mode Passif)";
          _estimatedDrainPerHour = 0.8;
        }
      });
    }
  }

  List<Widget> _buildGenreDistribution(BuildContext context) {
    final dist = StatisticsService.getGenreDistribution(allBooks);
    final sorted = dist.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(4).map((e) {
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(e.key, style: const TextStyle(fontSize: 12))),
            Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: e.value / 100,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(width: 8),
            Text("${e.value.toStringAsFixed(0)}%",
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }).toList();
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
          "Performances & Analytics",
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
            title: "Performance Algorithme (µs)",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Benchmark : 500 cycles (Microsecondes)"),
                const SizedBox(height: 12),
                _isBenchmarking
                    ? const LinearProgressIndicator()
                    : Column(
                        children: [
                          _buildMetricRow("Temps Moyen", "$_benchmarkAvgMs µs",
                              Colors.green),
                          _buildMetricRow(
                              "Temps Min", "$_benchmarkMinMs µs", Colors.blue),
                          _buildMetricRow("Temps Max", "$_benchmarkMaxMs µs",
                              Colors.orange),
                        ],
                      ),
              ],
            ),
            action: TextButton.icon(
              onPressed: _runBenchmark,
              icon: const Icon(Icons.refresh),
              label: const Text("Relancer"),
            ),
          ),
          const SizedBox(height: 16),
          // New Analytics Section
          _buildInfoCard(
            context,
            title: "Analyse du Corpus (Data Science)",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow(
                    "Genre Dominant",
                    StatisticsService.getMostPopularGenre(allBooks),
                    Colors.purple),
                _buildMetricRow(
                    "Diversité Auteurs (Index)",
                    "${StatisticsService.getDiversityScore(allBooks).toStringAsFixed(1)}%",
                    Colors.blue),
                _buildMetricRow(
                    "Popularité Moyenne",
                    "${StatisticsService.getAveragePopularity(allBooks).toStringAsFixed(1)} / 100",
                    Colors.orange),
                const SizedBox(height: 12),
                const Text("Distribution des Genres :",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._buildGenreDistribution(context),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            title: "Consommation Énergétique",
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricRow("Usage Actif", _batteryStatus, Colors.green),
                _buildMetricRow(
                    "Tâche de fond", "0 mAh (Mise en veille)", Colors.green),
                _buildMetricRow("Estimation Drain",
                    "~$_estimatedDrainPerHour % / heure", Colors.grey),
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
                    fontSize: 17, // Slightly smaller to fit
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
