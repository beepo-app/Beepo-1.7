import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/screens/Auth/lock_screen.dart';
import 'package:beepo/screens/auth/onboarding_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'session/foreground_session.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool? isSignedUp = Hive.box('beepo2.0').get('isSignedUp');

  checkState() async {
    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      await accountProvider.initDB();
      await walletProvider.initPlatformState();
      await accountProvider.getUserByUsernme('aje');
      await accountProvider.getAllUsers();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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

  @override
  void initState() {
    _monitorTotalUnreadBadge();
    checkState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beepo',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: isSignedUp == null
              ? const OnboardingScreen()
              : isSignedUp!
                  ? const LockScreen()
                  : const OnboardingScreen(),
        );
      },
      designSize: const Size(360, 546),
    );
  }
}
