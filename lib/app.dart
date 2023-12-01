import 'dart:convert';

import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/providers/chat_provider.dart';
import 'package:Beepo/providers/wallet_provider.dart';
import 'package:Beepo/screens/Auth/lock_screen.dart';
import 'package:Beepo/screens/auth/onboarding_screen.dart';
import 'package:Beepo/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool? isSignedUp = Hive.box('Beepo2.0').get('isSignedUp');
  List<xmtp.DecodedMessage>? data;
  checkState() async {
    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);

      await accountProvider.initDB();
      await walletProvider.initPlatformState();
      await accountProvider.getAllUsers();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    checkState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    chatProvider.findAndWatchAllMessages().listen((event) {
      print(event[0].content);
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
