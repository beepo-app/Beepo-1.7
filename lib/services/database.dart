import 'dart:math';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';

dbCreateUser(String image, Db db, String displayName, String ethAddress,
    btcAddress, encrypteData) async {
  await db.open();
  var usersCollection = db.collection('users');

  List usernameArray = displayName.split(' ');
  usernameArray.add((Random().nextInt(9900000) + 10000000).toString());
  String username = usernameArray.join('_');

  var val = await usersCollection.findOne(where.eq("username", username));

  if (val == null) {
    try {
      await usersCollection.insertOne({
        'username': username,
        'displayName': displayName,
        'ethAddress': ethAddress,
        'btcAddress': btcAddress,
        'image': image
      });

      await Hive.box('beepo2.0')
          .put('encryptedSeedPhrase', (encrypteData.base64));
      await Hive.box('beepo2.0').put('base64Image', image);
      await Hive.box('beepo2.0').put('ethAddress', ethAddress);
      await Hive.box('beepo2.0').put('btcAddress', btcAddress);
      await Hive.box('beepo2.0').put('displayName', displayName);
      await Hive.box('beepo2.0').put('username', username);
      await Hive.box('beepo2.0').put('isSignedUp', true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } else {
    await dbCreateUser(
        image, db, displayName, ethAddress, btcAddress, encrypteData);
  }

  await db.close();
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

        await Hive.box('beepo2.0').put('base64Image', image);
        await Hive.box('beepo2.0').put('displayName', displayName);
        await Hive.box('beepo2.0').put('username', newUsername);
        await Hive.box('beepo2.0').put('bio', bio);
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

Future<Map> dbGetUser(Db db, String username) async {
  await db.open();
  var usersCollection = db.collection('users');

  Map? val = await usersCollection.findOne(where.eq("username", username));

  if (val == null) {
    await db.close();
    return {'error': "User Not Found"};
  } else {
    await db.close();
    return val;
  }
}
