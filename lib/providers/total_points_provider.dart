import 'package:flutter/material.dart';

class TotalPointProvider extends ChangeNotifier {
  int totalPoints = 0;
  MapEntry<String, IconData> rankEntry = const MapEntry('', Icons.error);

  void updateTotalPoints({
    required int dailyPoints,
    required int withdrawPoints,
    required int pointProviderPoints,
    required int activeTimePoints,
    required int referralPoints,
  }) {
    totalPoints = dailyPoints +
        withdrawPoints +
        pointProviderPoints +
        activeTimePoints +
        referralPoints;
    rankEntry = setRank(totalPoints);
    notifyListeners();
  }

  MapEntry<String, IconData> setRank(int points) {
    if (points >= 0 && points <= 200) {
      return const MapEntry('Novice', Icons.sentiment_satisfied);
    }
    if (points >= 5000 && points < 10000) {
      return const MapEntry('Amateur', Icons.sentiment_neutral);
    }
    if (points >= 10000 && points < 18000) {
      return const MapEntry('Senior', Icons.sentiment_satisfied_alt);
    }
    if (points >= 18000 && points < 30000) {
      return const MapEntry('Enthusiast', Icons.emoji_events);
    }
    if (points >= 30000 && points < 38000) {
      return const MapEntry('Professional', Icons.work);
    }
    if (points >= 38000 && points < 50000) {
      return const MapEntry('Expert', Icons.star);
    }
    if (points >= 50000 && points < 100000) {
      return const MapEntry('Leader', Icons.leaderboard);
    }
    if (points >= 100000 && points < 500000) {
      return const MapEntry('Veteran', Icons.shield);
    }
    if (points >= 500000) return const MapEntry('Master', Icons.school);
    return const MapEntry("", Icons.error);
  }
}
