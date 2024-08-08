// import 'package:Beepo/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:mongo_dart/mongo_dart.dart' as mongo;

// class NewPointsProvider with ChangeNotifier {
//   int _points = 0;
//   DateTime _lastClaim = DateTime.fromMillisecondsSinceEpoch(0);
//   bool _canClaim = true;

//   int get points => _points;
//   bool get canClaim => _canClaim;

//   PointsProvider() {
//     fetchPoints();
//   }

//   Future<void> fetchPoints() async {
//     var db = await mongo.Db.create(
//         'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

//     if (db.state == mongo.State.closed || db.state == mongo.State.init) {
//       await db.open();
//     }

//     var pointsCollection = db.collection('points');

//     var box = await Hive.openBox('Beepo2.0');
//     var ethAddress = box.get('ethAddress');

//     if (ethAddress != null) {
//       var data = await pointsCollection
//           .findOne(mongo.where.eq('ethAddress', ethAddress));

//       if (data != null) {
//         _points = data['points'];
//         _lastClaim = data['lastClaim'];
//         _canClaim = DateTime.now().difference(_lastClaim).inDays >= 1;
//       } else {
//         _points = 0;
//         _canClaim = true;
//       }
//     } else {
//       _points = 0;
//       _canClaim = true;
//     }

//     notifyListeners();
//   }

//   Future<void> claimPoints(int points, String ethAddress) async {
//     if (_canClaim) {
//       await dbClaimDailyPoints(points, ethAddress);
//       _points += points;
//       _lastClaim = DateTime.now();
//       _canClaim = false;
//       notifyListeners();
//     } else {
//       print("Cannot claim points now, please come back later.");
//     }
//   }
// }

import 'package:Beepo/services/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class NewPointsProvider with ChangeNotifier {
  int _points = 0;
  DateTime _lastClaim = DateTime.fromMillisecondsSinceEpoch(0);
  bool _canClaim = true;

  int get points => _points;
  bool get canClaim => _canClaim;

  final String _boxName = 'Beepo2.0';
  final String _pointsKey = 'points';
  final String _lastClaimKey = 'lastClaim';
  final String _canClaimKey = 'canClaim';

  NewPointsProvider() {
    fetchPoints();
  }

  Future<void> fetchPoints() async {
    var box = await Hive.openBox(_boxName);

    // Check if points data is stored locally
    if (box.containsKey(_pointsKey)) {
      _points = box.get(_pointsKey);
      _lastClaim = DateTime.parse(box.get(_lastClaimKey));
      _canClaim = box.get(_canClaimKey);
    } else {
      // Fetch from MongoDB if not found locally
      var db = await mongo.Db.create(
          'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

      if (db.state == mongo.State.closed || db.state == mongo.State.init) {
        await db.open();
      }

      var pointsCollection = db.collection('points');
      var ethAddress = box.get('ethAddress');

      if (ethAddress != null) {
        var data = await pointsCollection
            .findOne(mongo.where.eq('ethAddress', ethAddress));

        if (data != null) {
          _points = data['points'];
          _lastClaim = DateTime.parse(data['lastClaim']);
          _canClaim = DateTime.now().difference(_lastClaim).inDays >= 1;
        } else {
          _points = 0;
          _canClaim = true;
        }

        // Save data to Hive
        box.put(_pointsKey, _points);
        box.put(_lastClaimKey, _lastClaim.toIso8601String());
        box.put(_canClaimKey, _canClaim);
      } else {
        _points = 0;
        _canClaim = true;
      }
    }

    notifyListeners();
  }

  Future<void> claimPoints(int points, String ethAddress) async {
    if (_canClaim) {
      await dbClaimDailyPoints(points, ethAddress);
      _points += points;
      _lastClaim = DateTime.now();
      _canClaim = false;

      var box = await Hive.openBox(_boxName);

      // Save updated points data to Hive
      box.put(_pointsKey, _points);
      box.put(_lastClaimKey, _lastClaim.toIso8601String());
      box.put(_canClaimKey, _canClaim);

      notifyListeners();
    } else {
      print("Cannot claim points now, please come back later.");
    }
  }
}
