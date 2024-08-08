import 'package:Beepo/services/database.dart';
import 'package:flutter/foundation.dart';

class TimeBasedPointsProvider with ChangeNotifier {
  int _points = 0;
  int _timeSpent = 0; // Time spent in seconds

  int get points => _points;
  int get timeSpent => _timeSpent;

  void updateTimeSpent(int timeInSeconds) {
    _timeSpent += timeInSeconds;
    notifyListeners();
  }

  Future<void> fetchPoints(String ethAddress) async {
    // Implement fetching logic if needed
  }

  Future<void> addTimeBasedPoints(String ethAddress) async {
    await dbUpdateTimeBasedPoints(ethAddress, _timeSpent);
    _timeSpent = 0; // Reset after sending to the server
    notifyListeners();
  }
}
