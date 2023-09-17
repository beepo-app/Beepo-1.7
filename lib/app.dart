import 'package:beepo/components/bottom_nav.dart';
import 'package:beepo/screens/auth/onboarding_screen.dart';
import 'package:beepo/screens/messaging/calls/calls_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          home: const OnboardingScreen(),
        );
      },
      designSize: const Size(360, 546),
    );
  }
}
