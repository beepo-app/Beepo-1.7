import 'package:beepo/screens/Auth/login_screen.dart';
import 'package:beepo/screens/Auth/pin_code.dart';
import 'package:beepo/screens/auth/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isSignedUp;
  checkState() async {
    bool? isSignedUpState = await Hive.box('beepo').get('isSignedUp');
    setState(() {
      if (isSignedUpState != null) {
        isSignedUp = false;
      } else {
        isSignedUp = false;
      }
    });
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
          home: isSignedUp
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
