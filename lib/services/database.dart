import 'dart:math';
import 'package:Beepo/session/foreground_session.dart';
import 'package:Beepo/widgets/toast.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:web3dart/web3dart.dart';

dbCreateUser(String image, Db db, String displayName, String ethAddress,
    btcAddress, encrypteData) async {
  if (db.state == State.closed) {
    await db.open();
  }

  var usersCollection = db.collection('users');

  List usernameArray = displayName.split(' ');
  usernameArray.add((Random().nextInt(9900000) + 10000000).toString());
  String username = usernameArray.join('_');

  var val = await usersCollection.findOne(where.eq("username", username));

  if (val == null) {
    try {
      await usersCollection.insertOne(
        {
          'username': username,
          'displayName': displayName,
          'ethAddress': ethAddress,
          'btcAddress': btcAddress,
          'image': image,
          'createdAt': DateTime.now()
        },
      );

      await Hive.box('Beepo2.0')
          .put('encryptedSeedPhrase', (encrypteData.base64));
      await Hive.box('Beepo2.0').put('base64Image', image);
      await Hive.box('Beepo2.0').put('ethAddress', ethAddress);
      await Hive.box('Beepo2.0').put('btcAddress', btcAddress);
      await Hive.box('Beepo2.0').put('displayName', displayName);
      await Hive.box('Beepo2.0').put('username', username);
      await Hive.box('Beepo2.0').put('isSignedUp', true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } else {
    await dbCreateUser(
        image, db, displayName, ethAddress, btcAddress, encrypteData);
  }

  // await db.close();
}

Stream<dynamic> dbWatchTx(Db db) {
  if (db.state == State.closed) {
    db.open();
  }
  var status = db.collection('status');

  var update = status.watch(<Map<String, Object>>[
    {
      r'$match': {'operationType': 'update'}
    }
  ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'));
  var insert = status.watch(<Map<String, Object>>[
    {
      r'$match': {'operationType': 'insert'}
    }
  ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'));

  print('watching all statueses 222');

  return StreamGroup.mergeBroadcast([update, insert]);
}

Stream<dynamic> dbWatchAllStatus(Db db) {
  if (db.state == State.closed) {
    db.open();
  }
  var status = db.collection('status');

  var update = status.watch(<Map<String, Object>>[
    {
      r'$match': {'operationType': 'update'}
    }
  ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'));
  var insert = status.watch(<Map<String, Object>>[
    {
      r'$match': {'operationType': 'insert'}
    }
  ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'));

  print('watching all statueses 222');

  return StreamGroup.mergeBroadcast([update, insert]);
}

Future<List<dynamic>> dbGetAllStatus(Db db) async {
  if (db.state == State.closed) {
    await db.open();
  }
  var status = db.collection('status');
  return status.find({
    "expireAt": {r'$lt': DateTime.now()}
  }).toList();
}

dbDeleteStatus(Db db, newData, String ethAddress) async {
  if (db.state == State.closed) {
    await db.open();
  }
  var status = db.collection('status');
  print(newData?.length);
  try {
    var d;
    if (newData?.length <= 1) {
      d = await status.deleteOne(where.eq("ethAddress", ethAddress));
      showToast('Deleted Successfully!');
      return;
    }
    print('deleting');
    d = await status.updateOne(
      where.eq("ethAddress", ethAddress),
      ModifierBuilder().set('data', newData),
      writeConcern: WriteConcern.majority,
    );
    showToast('Deleted Successfully!');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

dbAutoDeleteStatus(Db db, newData, String ethAddress) async {
  if (db.state == State.closed) {
    await db.open();
  }
  var status = db.collection('status');

  try {
    var d;
    if (newData?.length <= 1) {
      d = await status.deleteOne(where.eq("ethAddress", ethAddress));
      showToast('Deleted Successfully!');
      return;
    }
    print('deleting');
    d = await status.updateOne(
      where.eq("ethAddress", ethAddress),
      ModifierBuilder().set('data', newData),
      writeConcern: WriteConcern.majority,
    );
    showToast('Deleted Successfully!');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

dbUpdateStatusViewsCount(
    Db db, String id, String ethAddress, String viewerAddress) async {
  if (db.state == State.closed) {
    await db.open();
  }

  var status = db.collection('status');
  var data = await status.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    return;
  }

  List viewers = data['viewers'];
  viewers.add(viewerAddress);

  try {
    var d = await status.updateOne(
      where.eq("ethAddress", ethAddress),
      ModifierBuilder().set('viewers', viewers),
      writeConcern: WriteConcern.majority,
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

dbUploadStatus(String image, Db db, String message, String privacy,
    String ethAddress) async {
  if (db.state == State.closed) {
    await db.open();
  }
  var status = db.collection('status');

  var data = await status.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    try {
      status.createIndex(keys: {'expireAt': 1, 'expireAfterSeconds': 5000});
      DateTime finalTime =
          DateTime.now().add(const Duration(hours: 3, minutes: 0, seconds: 0));

      var d = await status.insertOne(
        {
          'ethAddress': ethAddress,
          'data': [
            {
              'privacy': privacy,
              'message': message,
              'ethAddress': ethAddress,
              'image': image,
              "expireAt": finalTime,
              'createdAt': DateTime.now(),
              "id": "$ethAddress-0"
            }
          ],
          "viewers": [],
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    showToast('Uploaded Successfully!');
    return;
  }

  List oldData = data['data'];
  DateTime finalTime =
      DateTime.now().add(const Duration(hours: 3, minutes: 0, seconds: 59));

  oldData.add({
    'privacy': privacy,
    'message': message,
    'ethAddress': ethAddress,
    'image': image,
    "expireAt": finalTime,
    'createdAt': DateTime.now(),
    "id": "$ethAddress-${oldData.length}"
  });

  try {
    var d = await status.updateOne(
      where.eq("ethAddress", ethAddress),
      ModifierBuilder().set('data', oldData),
      writeConcern: WriteConcern.majority,
    );
    showToast('Uploaded Successfully!');
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<Map<String, dynamic>> dbDeleteUser(Db db, ethAddress) async {
  await db.open();
  var usersCollection = db.collection('users');
  var status = db.collection('status');

  try {
    var d = await usersCollection.deleteOne(where.eq("ethAddress", ethAddress));
    print(d);
    d = await status.deleteOne(where.eq("ethAddress", ethAddress));
    showToast('Account Deleted Successfully!');
    session.clear();
    Hive.deleteBoxFromDisk("Beepo2.0");
    print(d);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  return ({'error': "An error occured!"});
}

Future<Map<String, dynamic>> dbUpdateUser(
    image, Db db, displayName, bio, newUsername, ethAddress) async {
  await db.open();
  var usersCollection = db.collection('users');

  var oldData =
      await usersCollection.findOne(where.eq("username", newUsername));

  if (oldData == null) {
    try {
      Map<String, dynamic>? newData =
          await usersCollection.findOne(where.eq("ethAddress", ethAddress));
      if (newData != null) {
        newData['username'] = newUsername;
        newData['displayName'] = displayName;
        newData['bio'] = bio;
        newData['image'] = image;

        await usersCollection.replaceOne(
            where.eq("ethAddress", ethAddress), newData);

        await Hive.box('Beepo2.0').put('base64Image', image);
        await Hive.box('Beepo2.0').put('displayName', displayName);
        await Hive.box('Beepo2.0').put('username', newUsername);
        await Hive.box('Beepo2.0').put('bio', bio);
        return (newData);
      } else {
        throw ({'error': "An error occured here!"});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } else {
    throw ({'error': "Username Already exists!"});
  }
  // await db.close();
  return ({'error': "An error occured!"});
}

Future<Map> dbGetAllUsers(Db db) async {
  try {
    if (db.state == State.closed) {
      await db.open();
    }
    print('fetchig sers');
    var usersCollection = db.collection('users');

    List<Map>? val = await usersCollection.find().toList();

    // ignore: unnecessary_null_comparison
    if (val == null) {
      throw ("User Not Found");
    } else {
      Iterable<Map<dynamic, dynamic>> data = val.map((e) => {
            'joined': e['createdAt'],
            'username': e['username'],
            'displayName': e['displayName'],
            'ethAddress': e['ethAddress'],
            'btcAddress': e['btcAddress'],
            'image': e['image'],
            'bio': e['bio'],
          });
      await Hive.box('Beepo2.0').put('allUsers', data.toList());
      return {'success': "done", "data": val};
    }
  } catch (e) {
    print(e);
    return {};
  }
}

Stream<dynamic> dbWatchAllUsers(Db db) {
  if (db.state == State.closed) {
    db.open();
  }
  var status = db.collection('users');

  var update = status.watch(<Map<String, Object>>[
    {
      r'$match': {'operationType': 'update'}
    }
  ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'));
  var insert = status.watch(<Map<String, Object>>[
    {
      r'$match': {'operationType': 'insert'}
    }
  ], changeStreamOptions: ChangeStreamOptions(fullDocument: 'updateLookup'));

  return StreamGroup.mergeBroadcast([update, insert]);
}

Future<Map> dbGetUser(Db db, String username) async {
  await db.open();
  var usersCollection = db.collection('users');

  Map? val = await usersCollection.findOne(where.eq("username", username));

  if (val == null) {
    // await db.close();
    throw ("User Not Found");
  } else {
    // await db.close();
    return {'success': "done", "data": val};
  }
}

Future<Map> dbGetUserByAddres(Db db, EthereumAddress ethAddress) async {
  await db.open();
  var usersCollection = db.collection('users');
  try {
    Map? val = await usersCollection
        .findOne(where.eq("ethAddress", ethAddress.toString()));

    if (val == null) {
      // await db.close();
      return {'error': "User Not Found"};
    } else {
      // await db.close();
      return val;
    }
  } catch (e) {
    return {'error acctProv': e};
  }
}

dbClaimDailyPoints(int points, String ethAddress) async {
  Db db = await Db.create(
      'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

  if (db.state == State.closed || db.state == State.init) {
    await db.open();
  }

  var pointsCollection = db.collection('points');

  var data = await pointsCollection.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    try {
      var d = await pointsCollection.insertOne(
        {
          'ethAddress': ethAddress,
          "points": points,
          "lastClaim": DateTime.now(),
          'referrals': 0
        },
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  data['points'] = data['points'] + points;
  DateTime lastClaim = data['lastClaim'] ?? DateTime.now();
  if (lastClaim.compareTo(lastClaim.add(const Duration(days: 1))) >= 0) {
    data['lastClaim'] = DateTime.now();
    try {
      var d = await pointsCollection.replaceOne(
          where.eq("ethAddress", ethAddress), data);
      print('Daily points claimed Successfully!');
      dbFetchPoints(ethAddress);
    } catch (e) {
      print(e);
    }
  }
  print("Please come back after " +
      (lastClaim.add(const Duration(days: 1)).hour).toString() +
      " hours!");
}

dbWithdrawPoints(String ethAddress) async {
  Db db = await Db.create(
      'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

  if (db.state == State.closed || db.state == State.init) {
    await db.open();
  }

  var pointsCollection = db.collection('points');

  var data = await pointsCollection.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    try {
      return {'error': "data not found"};
    } catch (e) {
      print(e);
    }
    return;
  }

  data['points'] = 0;

  try {
    var d = await pointsCollection.replaceOne(
        where.eq("ethAddress", ethAddress), data);
    print('Points Withdrwn Successfully!');
    return dbFetchPoints(ethAddress);
  } catch (e) {
    print(e);
  }
}

dbUpdatePoints(int points, String ethAddress) async {
  Db db = await Db.create(
      'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

  if (db.state == State.closed || db.state == State.init) {
    await db.open();
  }

  var pointsCollection = db.collection('points');

  var data = await pointsCollection.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    try {
      var d = await pointsCollection.insertOne(
        {
          'ethAddress': ethAddress,
          "points": points,
          "lastClaim": DateTime.now(),
          'referrals': 0
        },
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  data['points'] = data['points'] + points;

  try {
    var d = await pointsCollection.replaceOne(
        where.eq("ethAddress", ethAddress), data);

    return dbFetchPoints(ethAddress);
  } catch (e) {
    print(e);
  }

//   print('Please come back after 24 hours!');
}

dbFetchPoints(String ethAddress) async {
  Db db = await Db.create(
      'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

  if (db.state == State.closed || db.state == State.init) {
    await db.open();
  }

  print('running fetch points');
  var pointsCollection = db.collection('points');

  var data = await pointsCollection.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    try {
      return {"error": 'not found'};
    } catch (e) {
      print(e);
    }
  }

  try {
    return data;
  } catch (e) {
    print(e);
  }
}

dbUpdateReferrals(String refId) async {
  Db db = await Db.create(
      'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

  if (db.state == State.closed || db.state == State.init) {
    await db.open();
  }

  print('update refs fetch points');
  var pointsCollection = db.collection('points');
  var usersCollection = db.collection('users');

  var data = await usersCollection.findOne(where.eq('username', refId));

  if (data == null) {
    try {
      return {"error": 'user not found'};
    } catch (e) {
      print(e);
    }
    return;
  }

  var ethAddress = data['ethAddress'];
  var pointsData =
      await pointsCollection.findOne(where.eq('ethAddress', ethAddress));

  if (pointsData == null) {
    try {
      var d = await pointsCollection.insertOne(
        {'ethAddress': ethAddress, "points": 100, 'referrals': 1},
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  pointsData['points'] = pointsData['points'] + 100;
  pointsData['referrals'] = pointsData['referrals'] + 1;

  try {
    var d = await pointsCollection.replaceOne(
        where.eq("ethAddress", ethAddress), pointsData);
    print('ref added Successfully!');
    dbFetchPoints(ethAddress);
  } catch (e) {
    print(e);
  }

  print('Please come back after 24 hours!');
}

String setRank(int points) {
  if (points < 5000) return 'Novice';
  if (points >= 5000 && points < 10000) return 'Amateur';
  if (points >= 10000 && points < 18000) return 'Senior';
  if (points >= 18000 && points < 30000) return 'Enthusiast';
  if (points >= 30000 && points < 38000) return 'Professional';
  if (points >= 38000 && points < 50000) return 'Expert';
  if (points >= 50000 && points < 100000) return 'Leader';
  if (points >= 100000 && points < 500000) return 'Veteran';
  if (points >= 500000) return 'Master';
  return "";
}
