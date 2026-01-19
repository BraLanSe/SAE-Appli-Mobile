import 'package:flutter/foundation.dart';
import 'package:battery_plus/battery_plus.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  final Battery _battery = Battery();

  factory PerformanceMonitor() {
    return _instance;
  }

  PerformanceMonitor._internal();

  /// Mesure le temps d'exécution d'une fonction asynchrone et logue le résultat
  Future<T> measureAsync<T>(String label, Future<T> Function() function) async {
    final stopwatch = Stopwatch()..start();

    // Log battery level start (optional, as it's slow to query)
    // int startBattery = await _battery.batteryLevel;

    debugPrint("[PERF] Start: $label");

    try {
      final result = await function();
      stopwatch.stop();
      debugPrint(
          "[PERF] $label executed in ${stopwatch.elapsedMilliseconds}ms");

      // Check battery impact if needed (usually for long tasks)
      // int endBattery = await _battery.batteryLevel;
      // if (startBattery != endBattery) {
      //   debugPrint("[PERF] Battery changed: $startBattery% -> $endBattery%");
      // }

      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
          "[PERF] $label FAILED after ${stopwatch.elapsedMilliseconds}ms: $e");
      rethrow;
    }
  }

  /// Mesure le temps d'exécution d'une fonction synchrone
  T measureSync<T>(String label, T Function() function) {
    final stopwatch = Stopwatch()..start();
    debugPrint("[PERF] Start Sync: $label");

    try {
      final result = function();
      stopwatch.stop();
      debugPrint(
          "[PERF] $label executed in ${stopwatch.elapsedMilliseconds}ms");
      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint(
          "[PERF] $label FAILED after ${stopwatch.elapsedMilliseconds}ms: $e");
      rethrow;
    }
  }

  /// Affiche les statistiques de batterie instantanées
  Future<void> logBatteryStats() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      debugPrint("[BATTERY] Level: $level%, State: $state");
    } catch (e) {
      debugPrint("[BATTERY] Failed to get stats: $e");
    }
  }

  /// Récupère le niveau de batterie actuel
  Future<int> getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (e) {
      debugPrint("[BATTERY] Failed to get level: $e");
      return 100; // Assume full if failure to avoid forcing Eco mode
    }
  }
}
