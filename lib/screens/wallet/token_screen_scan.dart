import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/wallet/received_assets_screen.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TokenScreenScan extends StatelessWidget {
  const TokenScreenScan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        toolbarHeight: 50.h,
        title: AppText(
          text: "Recieve Token",
          fontSize: 20.sp,
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ReceivedAssetScreen();
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 15.h),
            Image.asset(
              'assets/Celo.png',
              height: 80.h,
              width: 80.w,
            ),
            AppText(
              text: "BRISE",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
            SizedBox(height: 15.h),
            SizedBox(
              height: 200.h,
              width: 250.w,
              child: Image.asset("assets/scan.png"),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "0x0E61830c8e35db159eF8",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryColor,
                  ),
                ),
                const Icon(
                  Icons.folder,
                  color: AppColors.secondaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
