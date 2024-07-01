import 'package:Beepo/services/database.dart';
import 'package:Beepo/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UpdateReferralProvider extends ChangeNotifier {
  bool isLoading = false;
  int points = 0;
  int referrals = 0;

  UpdateReferralProvider() {
    init();
  }

  Future<void> init() async {
    points = await Hive.box('Beepo2.0').get('points', defaultValue: 0);
    referrals = await Hive.box('Beepo2.0').get('referrals', defaultValue: 0);
    notifyListeners();
  }

  Future<void> updateReferrals(String refId) async {
    isLoading = true;
    notifyListeners();

    try {
      var result = await dbUpdateReferrals(refId);
      if (result != null && result['error'] == null) {
        points = result['points'];
        referrals = result['referrals'];
        await Hive.box('Beepo2.0').put('points', points);
        await Hive.box('Beepo2.0').put('referrals', referrals);
      }
    } catch (e) {
      beepoPrint(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
