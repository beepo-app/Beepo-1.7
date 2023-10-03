import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/screens/Auth/pin_code.dart';
import 'package:beepo/screens/auth/onboarding_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool? isSignedUp = Hive.box('beepo2.0').get('isSignedUp');
  // late bool isLocked = false;
  checkState() async {
    try {
      final accountProvider =
          Provider.of<AccountProvider>(context, listen: false);
      await accountProvider.initDB();

      // bool? isSignedUpState = await Hive.box('beepo2.0').get('isSignedUp');
      // bool? isLockedState = await Hive.box('beepo2.0').get('isLocked');
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
                  ? const PinCode(
                      isSignedUp: true,
                    )
                  : const OnboardingScreen(),
        );
      },
      designSize: const Size(360, 546),
    );
  }
}
