import 'package:Beepo/app.dart';
import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/providers/chat_provider.dart';
import 'package:Beepo/providers/wallet_provider.dart';
import 'package:Beepo/services/notification_service.dart';
import 'package:Beepo/utils/encrypted_seed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'session/foreground_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initializeNotification();

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
            create: (_) => ChatProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => AccountProvider(),
          ),
        ],
        builder: (context, _) {
          return const GetMaterialApp(
            home: MyApp(),
          );
        }),
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
