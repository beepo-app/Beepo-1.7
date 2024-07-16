import 'package:Beepo/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'package:hive/hive.dart';
import '../utils/logger.dart';
import 'account_provider.dart';

class UpdateActiveTimeProvider extends ChangeNotifier {
  bool isLoading = false;
  int points = 0;
  int dailyActiveTime = 0;
  Timer? _timer;
  DateTime _lastPaused = DateTime.now();

  UpdateActiveTimeProvider() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initActivityTimer();
    });
    points = Hive.box('Beepo2.0').get('points', defaultValue: 0);
    dailyActiveTime =
        Hive.box('Beepo2.0').get('dailyActiveTime', defaultValue: 0);
    beepoPrint(
        'Initial points: $points, Initial daily active time: $dailyActiveTime');
  }

  Future<void> initActivityTimer() async {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      dailyActiveTime++;
      if (dailyActiveTime >= 10800) {
        _rewardPoints();
      }
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _rewardPoints() async {
    isLoading = true;
    notifyListeners();

    try {
      await dbUpdateActiveTime(
          AccountProvider().ethAddress.toString(), dailyActiveTime);
      points += 500; // Add points for 3 hours of activity
      dailyActiveTime = 0; // Reset daily active time after rewarding points
      await Hive.box('Beepo2.0').put('points', points); // Save points to Hive
      await Hive.box('Beepo2.0').put(
          'dailyActiveTime', dailyActiveTime); // Save daily active time to Hive
      beepoPrint(
          'Updated points: $points, Updated daily active time: $dailyActiveTime');
    } catch (e) {
      beepoPrint(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateDailyActiveTime() {
    dailyActiveTime += DateTime.now().difference(_lastPaused).inSeconds;
    _lastPaused = DateTime.now();
    notifyListeners();
  }

  void onResumed() {
    _startTimer();
    _lastPaused = DateTime.now();
  }

  void onPaused() {
    _stopTimer();
    updateDailyActiveTime();
  }
}
