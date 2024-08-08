import 'package:Beepo/services/database.dart'; // Assuming dbFetchReferrals is defined here
import 'package:flutter/material.dart';

class ReferralProvider with ChangeNotifier {
  int _referrals = 0;
  int _points = 0;

  int get referrals => _referrals;
  int get points => _points;

  Future<void> fetchReferrals(String ethAddress) async {
    try {
      var data = await dbFetchReferrals(ethAddress);
      if (data != null) {
        _referrals = data['referrals'] ?? 0;
        _points = data['points'] ?? 0;
      }
    } catch (e) {
      print("Error fetching referrals: $e");
      // Handle the error appropriately, e.g., set an error state
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateReferrals(String refId) async {
    var result = await dbUpdateReferrals(refId);
    if (result.containsKey('success')) {
      _referrals += 1;
      _points += 100; // Assuming each referral adds 100 points
      notifyListeners();
    } else {
      print(result['error']);
    }
  }
}
