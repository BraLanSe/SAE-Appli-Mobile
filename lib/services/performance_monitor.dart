// lib/services/performance_monitor.dart
import 'dart:developer'; // Pour la console

class PerformanceMonitor {
  /// Démarre un chronomètre
  static Stopwatch start() {
    final s = Stopwatch();
    s.start();
    return s;
  }

  /// Arrête et affiche le temps (Simule un log de performance système)
  static void stop(Stopwatch s, String actionName) {
    s.stop();
    // Tu pourras montrer ces logs dans ton rapport "Optimisation"
    log("PERFORMANCE [$actionName] : Exécuté en ${s.elapsedMilliseconds} ms");
    

  }
}