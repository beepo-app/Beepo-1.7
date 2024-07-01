import 'package:Beepo/services/database.dart';
import 'package:Beepo/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UpdatedPointsProvider extends ChangeNotifier {
  bool isLoading = false;
  int points = 0;

  UpdatedPointsProvider() {
    loadFromHive();
  }

  Future<void> loadFromHive() async {
    points = await Hive.box('Beepo2.0').get('points', defaultValue: 0);
    notifyListeners();
  }

  Future<void> _saveToHive() async {
    await Hive.box('Beepo2.0').put('points', points);
  }

  Future<void> updatePoints(int pointsToAdd, String ethAddress) async {
    isLoading = true;
    notifyListeners();

    try {
      var result = await dbUpdatePoints(pointsToAdd, ethAddress);
      if (result != null) {
        points = result['points'];
        await _saveToHive();
      }
    } catch (e) {
      beepoPrint(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
