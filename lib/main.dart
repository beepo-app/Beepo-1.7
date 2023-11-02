import 'package:beepo/app.dart';
import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/utils/encrypted_seed.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'session/foreground_session.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EncryptSeedAdapter());
  await Hive.openBox('beepo2.0');
  await dotenv.load(fileName: ".env");

  await session.loadSaved();
  _monitorTotalUnreadBadge();

  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(),
        ),
      ],
      builder: (context, _) => const GetMaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

void _monitorTotalUnreadBadge() {
  if (!session.initialized) {
    return;
  }
  session.watchTotalNewMessageCount().listen((count) {
    if (count > 0) {
      FlutterAppBadger.updateBadgeCount(count);
    } else {
      FlutterAppBadger.removeBadge();
    }
  });
}
