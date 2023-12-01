import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:web3dart/web3dart.dart';

dbCreateUser(String image, Db db, String displayName, String ethAddress, btcAddress, encrypteData) async {
  await db.open();
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

  await db.close();
}

dbUploadStatus(String image, Db db, String privacy, String message, String username) async {
  await db.open();
  var usersCollection = db.collection('status');

  try {
    await usersCollection.insertOne(
      {
        'privacy': privacy,
        'message': message,
        'image': image,
        'createdAt': DateTime.now(),
      },
    );
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  await db.close();
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
  await db.close();
  return ({'error': "An error occured!"});
}

Future<Map> dbGetAllUsers(Db db) async {
  await db.open();
  var usersCollection = db.collection('users');

  List<Map>? val = await usersCollection.find().toList();

  // ignore: unnecessary_null_comparison
  if (val == null) {
    await db.close();
    throw ("User Not Found");
  } else {
    await db.close();
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
}

Future<Map> dbGetUser(Db db, String username) async {
  await db.open();
  var usersCollection = db.collection('users');

  Map? val = await usersCollection.findOne(where.eq("username", username));

  if (val == null) {
    await db.close();
    throw ("User Not Found");
  } else {
    await db.close();
    return {'success': "done", "data": val};
  }
}

Future<Map> dbGetUserByUsernme(Db db, String username) async {
  var usersCollection = db.collection('users');

  var agg = [
    {
      '\$search': {
        'index': 'dynamicUsernameSearch',
        'autocomplete': {
          'path': 'username',
          'query': username,
          'fuzzy': {'maxEdits': 2, 'prefixLength': 1, 'maxExpansions': 256}
        },
        'highlight': {'path': 'username'}
      }
    },
  ];

  print('fetchin user by ame');
  var val = await usersCollection.aggregateToStream(agg).toList();

  if (val == null || val.isEmpty) {
    await db.close();
    throw ("User Not Found");
  } else {
    await db.close();
    return {'status': 'success', "data": val};
  }
}

Future<Map> dbGetUserByAddres(Db db, EthereumAddress ethAddress) async {
  await db.open();
  var usersCollection = db.collection('users');
  try {
    Map? val = await usersCollection.findOne(where.eq("ethAddress", ethAddress.toString()));

    print(val);

    if (val == null) {
      await db.close();
      return {'error': "User Not Found"};
    } else {
      await db.close();
      return val;
    }
  } catch (e) {
    return {'error acctProv': e};
  }
}
