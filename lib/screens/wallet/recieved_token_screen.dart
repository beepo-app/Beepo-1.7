import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecievedTokenScreen extends StatelessWidget {
  const RecievedTokenScreen({super.key});

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
          onPressed: () {},
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
              text: "CELO",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ],
        ),
      ),
    );
  }
}
