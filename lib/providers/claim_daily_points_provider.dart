import 'package:Beepo/services/database.dart';
import 'package:Beepo/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ClaimDailyPointsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool canClaim = true;
  int points = 0;
  DateTime lastClaim = DateTime.now().subtract(const Duration(days: 1));

  ClaimDailyPointsProvider() {
    loadFromHive();
  }

  Future<void> loadFromHive() async {
    points = await Hive.box('Beepo2.0').get('points', defaultValue: 0);
    lastClaim = await Hive.box('Beepo2.0').get('lastClaim',
        defaultValue: DateTime.now().subtract(const Duration(days: 1)));
    canClaim = DateTime.now().difference(lastClaim).inHours >= 24;
    notifyListeners();
  }

  Future<void> claimPoints(String ethAddress) async {
    if (!canClaim) return;

    isLoading = true;
    notifyListeners();

    try {
      await dbClaimDailyPoints(20, ethAddress); // Pass 20 points as parameter
      points += 20; // Assume 20 points are added in dbClaimDailyPoints
      lastClaim = DateTime.now();
      canClaim = false;
      await savePointsToHive(points, lastClaim);
    } catch (e) {
      beepoPrint(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> savePointsToHive(int newPoints, DateTime newLastClaim) async {
    await Hive.box('Beepo2.0').put('points', newPoints);
    await Hive.box('Beepo2.0').put('lastClaim', newLastClaim);
  }

  DateTime get nextClaimTime => lastClaim.add(const Duration(days: 1));
}
