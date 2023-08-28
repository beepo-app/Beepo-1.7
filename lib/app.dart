import 'package:beepo/screens/wallet/transfer_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
          home: const TransferSuccess(),
        );
      },
      designSize: const Size(360, 546),
    );
  }
}
