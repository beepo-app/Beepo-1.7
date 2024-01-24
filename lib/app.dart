import 'dart:convert';

import 'package:Beepo/components/bottom_nav.dart';
import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/providers/chat_provider.dart';
import 'package:Beepo/providers/wallet_provider.dart';
import 'package:Beepo/screens/Auth/lock_screen.dart';
import 'package:Beepo/screens/auth/onboarding_screen.dart';
import 'package:Beepo/services/notification_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AppLifecycleListener _lifeCycleListener;
  late bool? isSignedUp = Hive.box('Beepo2.0').get('isSignedUp');
  late bool isLocked = Hive.box('Beepo2.0').get('isLocked') ?? false;
  List<xmtp.DecodedMessage>? data;

  checkState() async {
    try {
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final acctProvider = Provider.of<AccountProvider>(context, listen: false);

      await acctProvider.initDB();
      await walletProvider.initPlatformState();
      await acctProvider.getAllUsers();

      chatProvider.findAndWatchAllStatuses(acctProvider.db).listen((event) {
        chatProvider.saveStatuses(acctProvider.db);
      });

      acctProvider.findAndWatchAllUsers(acctProvider.db).listen((event) async {
        await acctProvider.getAllUsers();
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    _lifeCycleListener = AppLifecycleListener(onStateChange: _onLifeCycleChanged);
    checkState();
    super.initState();
  }

  @override
  void dispose() {
    _lifeCycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    Hive.box('Beepo2.0').watch(key: "isLocked").listen((event) {
      //print("BoxEvent | key: ${event.key}, value: ${event.value}, deleted: ${event.deleted},");
      setState(() {
        isLocked = event.value;
      });
    });

    chatProvider.findAndWatchAllMessages().listen((event) {
      chatProvider.updateMessages(event);
    });

    chatProvider.findAndWatchAllConvos().listen((event) {
      chatProvider.updateConvos(event);
    });

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

@override
void _onLifeCycleChanged(AppLifecycleState state) async {
  bool isAutoLockSwitch = Hive.box('Beepo2.0').get('isAutoLockSwitch') ?? false;
  if (isAutoLockSwitch) {
    switch (state) {
      case AppLifecycleState.resumed:
        print('Back to app');
        break;
      case AppLifecycleState.paused:
        Hive.box('Beepo2.0').put('isLocked', true);
        Get.to(() => const LockScreen());
        print('left app paused');
        break;
      case AppLifecycleState.detached:
        Hive.box('Beepo2.0').put('isLocked', true);
        Get.to(() => const LockScreen());
        print('left app detached');
        break;
      case AppLifecycleState.inactive:
        // Hive.box('Beepo2.0').put('isLocked', true);
        // Get.to(() => const LockScreen());
        print('left app inactive');
        break;
      case AppLifecycleState.hidden:
        Hive.box('Beepo2.0').put('isLocked', true);
        Get.to(() => const LockScreen());
        print('left app hidden');
        break;
    }
  }
}

void sendWalletNotification(Map data) async {
  try {
    await NotificationService.showNotifications(
      title: "You have received ",
      body: "You have received ",
      summary: '',
      payload: {'navigate': "true", "destination": "Wallet"},
    );
  } catch (e) {
    print(e);
  }
}

void sendNotification(xmtp.DecodedMessage msg) async {
  List? users = Hive.box('Beepo2.0').get('allUsers', defaultValue: null);

  Map? d = users?.firstWhereOrNull((element) => element['ethAddress'].toString() == msg.sender.toString());

  try {
    await NotificationService.showNotifications(
      title: d?['displayName'] ?? msg.sender.toString(),
      body: msg.content.toString(),
      summary: '',
      img: d?['image'],
      payload: {'navigate': "true", 'topic': msg.topic, 'userData': jsonEncode(d), 'sender': msg.sender.toString()},
    );
  } catch (e) {
    print(e);
  }
}
