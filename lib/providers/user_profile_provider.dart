import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  int _xp = 0;
  List<String> _badges = [];

  int get xp => _xp;
  List<String> get badges => _badges;

  // Level Logic: Level 1 = 0-99, Level 2 = 100-299...
  // Simple formula: Level = (XP / 100).floor() + 1
  int get level => (_xp / 100).floor() + 1;

  // XP require for next level
  int get nextLevelXp => level * 100;

  // Progress to next level (0.0 to 1.0)
  double get levelProgress {
    int currentLevelBaseXp = (level - 1) * 100;
    int xpInLevel = _xp - currentLevelBaseXp;
    return xpInLevel / 100.0;
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _xp = prefs.getInt('user_xp') ?? 0;
    _badges = prefs.getStringList('user_badges') ?? [];
    notifyListeners();
  }

  Future<void> addXp(int amount) async {
    int oldLevel = level;
    _xp += amount;

    // Level Up Check
    if (level > oldLevel) {
      // Could trigger a notification or event here
      // For now, we trust the UI to react to the change
    }

    _checkBadges();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_xp', _xp);
    notifyListeners();
  }

  void _checkBadges() async {
    // Simple Badge Logic
    // 500 XP -> "Rat de bibliothèque"
    if (_xp >= 500 && !_badges.contains('bookworm')) {
      _badges.add('bookworm');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('user_badges', _badges);
    }

    // More badge logic can be added here
  }

  // Reset for debug
  Future<void> resetProfile() async {
    _xp = 0;
    _badges = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_xp');
    await prefs.remove('user_badges');
    notifyListeners();
  }
}
