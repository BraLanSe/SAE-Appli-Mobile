import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../services/statistics_service.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final historyProvider = Provider.of<HistoryProvider>(context);
    final history = historyProvider.history;

    // Calculate stats
    final booksRead = history.length;
    final totalPages = StatisticsService.getTotalPagesRead(history);
    final genreDist = StatisticsService.getGenreDistribution(history);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistiques",
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text("Aucune donnée disponible",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text("Commencez à lire pour voir vos statistiques !",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          "$booksRead",
                          "Livres terminés",
                          Icons.check_circle_outline,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          context,
                          "$totalPages",
                          "Pages tournées",
                          Icons.auto_stories,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Genre Distribution Pie Chart
                  Text(
                    "Répartition des Genres",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _getGroupedGenreSections(genreDist),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLegend(
                      genreDist), // You might want to update legend to match grouped sections, but for now simple is ok or adapt.

                  const SizedBox(height: 32),

                  // Activity Bar Chart
                  Text(
                    "Activité de Lecture (Pages/Jour)",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 220,
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (_) => Colors.blueGrey,
                          ),
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                );
                                Widget text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = const Text('Lu', style: style);
                                    break;
                                  case 1:
                                    text = const Text('Ma', style: style);
                                    break;
                                  case 2:
                                    text = const Text('Me', style: style);
                                    break;
                                  case 3:
                                    text = const Text('Je', style: style);
                                    break;
                                  case 4:
                                    text = const Text('Ve', style: style);
                                    break;
                                  case 5:
                                    text = const Text('Sa', style: style);
                                    break;
                                  case 6:
                                    text = const Text('Di', style: style);
                                    break;
                                  default:
                                    text = const Text('', style: style);
                                }
                                return SideTitleWidget(
                                  meta: meta,
                                  space: 4,
                                  child: text,
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          // Mock Data for the week
                          _makeBarGroup(0, 5, theme),
                          _makeBarGroup(1, 12, theme),
                          _makeBarGroup(2, 8, theme),
                          _makeBarGroup(3, 20, theme),
                          _makeBarGroup(4, 15, theme),
                          _makeBarGroup(5, 35, theme),
                          _makeBarGroup(6, 45, theme),
                        ],
                        gridData: const FlGridData(show: false),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Technical Metrics (Geek & Chic)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B), // Dark slate
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.indigoAccent.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigoAccent.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.terminal,
                                color: Colors.greenAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "MÉTRIQUES SYSTÈME",
                              style: GoogleFonts.robotoMono(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1.2),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white24, height: 24),
                        _buildTechRow("Temps moyen de recommandation", "12ms"),
                        _buildTechRow("Mode Batterie", "Optimisé (Normal)"),
                        _buildTechRow(
                            "Moteur de recherche", "Vectors + Jaccard"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, ThemeData theme) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x > 4
              ? theme.colorScheme.secondary
              : theme.colorScheme.primary, // Weekend highlighted
          width: 16,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60, // Max scale
            color: Colors.grey.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildTechRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.robotoMono(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getGroupedGenreSections(
      Map<String, double> genreDist) {
    final List<Color> colors = [
      Colors.indigo,
      Colors.teal,
      Colors.amber,
      Colors.redAccent,
      Colors.purple,
    ];

    double otherValue = 0;
    List<MapEntry<String, double>> mainSections = [];

    // Group < 5%
    for (var entry in genreDist.entries) {
      if (entry.value < 5.0) {
        otherValue += entry.value;
      } else {
        mainSections.add(entry);
      }
    }

    // Sort main sections
    mainSections.sort((a, b) => b.value.compareTo(a.value));

    List<PieChartSectionData> sections = [];
    int index = 0;

    for (var entry in mainSections) {
      final color = colors[index % colors.length];
      sections.add(PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.value.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _Badge(entry.key, size: 40, borderColor: color),
        badgePositionPercentageOffset: 1.3,
      ));
      index++;
    }

    if (otherValue > 0) {
      sections.add(PieChartSectionData(
        color: Colors.grey,
        value: otherValue,
        title: '${otherValue.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        badgeWidget: const _Badge("Autres", size: 40, borderColor: Colors.grey),
        badgePositionPercentageOffset: 1.3,
      ));
    }

    return sections;
  }

  Widget _buildLegend(Map<String, double> genreDist) {
    // Legend logic can remain simple or adapted
    return const SizedBox
        .shrink(); // Using badges instead of legend for cleaner look as per "Data Viz Expert"
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.text, {
    required this.size,
    required this.borderColor,
  });
  final String text;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size * 2.5, // Wider for text
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.roboto().fontFamily,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
