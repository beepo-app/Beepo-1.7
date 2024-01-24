import 'dart:math';
import 'package:Beepo/session/foreground_session.dart';
import 'package:Beepo/widgets/toast.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:web3dart/web3dart.dart';

dbCreateUser(String image, Db db, String displayName, String ethAddress, btcAddress, encrypteData) async {
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

      await Hive.box('Beepo2.0').put('encryptedSeedPhrase', (encrypteData.base64));
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
    await dbCreateUser(image, db, displayName, ethAddress, btcAddress, encrypteData);
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

  print('gtting all statueses 111');

  var status = db.collection('status');
  return status.find().toList();
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

dbUpdateStatusViewsCount(Db db, String id, String ethAddress, String viewerAddress) async {
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

dbUploadStatus(String image, Db db, String message, String privacy, String ethAddress) async {
  if (db.state == State.closed) {
    await db.open();
  }
  var status = db.collection('status');

  var data = await status.findOne(where.eq('ethAddress', ethAddress));

  if (data == null) {
    try {
      status.createIndex(keys: {'expireAt': 1, 'expireAfterSeconds': 0});
      DateTime finalTime = DateTime.now().add(const Duration(hours: 0, minutes: 0, seconds: 59));

      var d = await status.insertOne(
        {
          'ethAddress': ethAddress,
          'data': [
            {
              'privacy': privacy,
              'message': message,
              'ethAddress': ethAddress,
              'image': image,
              'createdAt': DateTime.now(),
              "expireAt": finalTime,
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

  DateTime finalTime = DateTime.now().add(const Duration(hours: 0, minutes: 0, seconds: 59));

  oldData.add({
    'privacy': privacy,
    'message': message,
    'ethAddress': ethAddress,
    'image': image,
    'createdAt': DateTime.now(),
    "expireAt": finalTime,
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

Future<Map<String, dynamic>> dbUpdateUser(image, Db db, displayName, bio, newUsername, ethAddress) async {
  await db.open();
  var usersCollection = db.collection('users');

  var oldData = await usersCollection.findOne(where.eq("username", newUsername));

  if (oldData == null) {
    try {
      Map<String, dynamic>? newData = await usersCollection.findOne(where.eq("ethAddress", ethAddress));
      if (newData != null) {
        newData['username'] = newUsername;
        newData['displayName'] = displayName;
        newData['bio'] = bio;
        newData['image'] = image;

        await usersCollection.replaceOne(where.eq("ethAddress", ethAddress), newData);

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
    Map? val = await usersCollection.findOne(where.eq("ethAddress", ethAddress.toString()));

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
