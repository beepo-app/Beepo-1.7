import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';

dbCreateUser(String image, Db db, String displayName, String ethAddress,
    encrypteData) async {
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
        'image': image
      });

      await Hive.box('beepo2.0')
          .put('encryptedSeedPhrase', (encrypteData.base64));
      await Hive.box('beepo2.0').put('base64Image', image);
      await Hive.box('beepo2.0').put('ethAddress', ethAddress);
      await Hive.box('beepo2.0').put('displayName', displayName);
      await Hive.box('beepo2.0').put('username', username);
      await Hive.box('beepo2.0').put('isSignedUp', true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  } else {
    await dbCreateUser(image, db, displayName, ethAddress, encrypteData);
  }

  await db.close();
}
