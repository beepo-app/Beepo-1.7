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
  DateTime lastClaim = DateTime.now().subtract(const Duration(days: 1));
  Timer? _timer;
  DateTime _lastPaused = DateTime.now();

  UpdateActiveTimeProvider() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      initActivityTimer();
    });
    points = Hive.box('Beepo2.0').get('points', defaultValue: 0);
  }

  Future<void> initActivityTimer() async {
    WidgetsBinding.instance.lifecycleState;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      dailyActiveTime++;
      if (dailyActiveTime >= 10800) {
        // 10800 seconds = 3 hours
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


// class UpdateActiveTimeProvider extends ChangeNotifier {
//   bool isLoading = false;
//   int points = 0;
//   int dailyActiveTime = 0;
//   DateTime lastClaim = DateTime.now().subtract(const Duration(days: 1));
//   Timer? _timer;
//   DateTime _lastPaused = DateTime.now();

//   UpdateActiveTimeProvider() {
//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       initActivityTimer();
//     });
//     points = Hive.box('Beepo2.0').get('points', defaultValue: 0);
//   }

//   Future<void> initActivityTimer() async {
//     WidgetsBinding.instance.addObserver(LifecycleEventHandler(
//       onResume:  onResumed,
//       onPause: onPaused,
//     ));
//     _startTimer();
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       dailyActiveTime++;
//       if (dailyActiveTime >= 10800) {
//         _rewardPoints();
//       }
//       notifyListeners();
//     });
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//   }

//   Future<void> _rewardPoints() async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       await dbUpdateActiveTime(
//           AccountProvider().ethAddress.toString(), dailyActiveTime);
//       points += 500;
//       dailyActiveTime = 0; // Reset daily active time after rewarding points
//       await Hive.box('Beepo2.0').put('points', points); // Save points to Hive
//     } catch (e) {
//       beepoPrint(e);
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }

//   void updateDailyActiveTime() {
//     dailyActiveTime += DateTime.now().difference(_lastPaused).inSeconds;
//     _lastPaused = DateTime.now();
//     notifyListeners();
//   }

//   Future<void> onResumed() async{
//     _startTimer();
//     _lastPaused = DateTime.now();
//   }

//   Future<void> onPaused() {
//     _stopTimer();
//    return updateDailyActiveTime();
//   }
// }



