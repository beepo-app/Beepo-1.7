import 'package:beepo/app.dart';
import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/utils/encrypted_seed.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EncryptSeedAdapter());
  await Hive.openBox('beepo2.0');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountProvider(),
        ),
        ChangeNotifierProvider<XMTPProvider>(
          create: (_) => XMTPProvider(),
        ),
      ],
      builder: (context, _) => const GetMaterialApp(
        home: MyApp(),
      ),
    ),
  );
}
