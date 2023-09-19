import 'dart:math';

import 'package:flutter/services.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;

import 'package:web3dart/web3dart.dart';

createUser(String image, String displayName, String ethAddress) async {
  var db = await Db.create(
      'mongodb+srv://admin:admin1234@cluster0.x31efel.mongodb.net/?retryWrites=true&w=majority');

  await db.open();
  var usersCollection = db.collection('users');

  List usernameArray = displayName.split(' ');
  usernameArray.add((Random().nextInt(9900000) + 10000000).toString());
  String username = usernameArray.join('_');

  var val = await usersCollection.findOne(where.eq("username", username));

  print(val);

  if (val == null) {
    await usersCollection.insertOne({
      'username': username,
      'displayName': displayName,
      'ethAddress': ethAddress,
      'image': image
    });
  } else {
    await createUser(image, displayName, ethAddress);
  }

  // await db.ensureIndex('users', keys: {'login': -1});

  // var res1 = await usersCollection.find().toList();

  await db.close();
}
