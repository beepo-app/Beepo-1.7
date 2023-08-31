import 'package:beepo/components/filled_button.dart';
import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class TransferSuccess extends StatelessWidget {
  const TransferSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        centerTitle: true,
        toolbarHeight: 40.h,
        title: Text(
          "Transaction",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20.sp,
            color: AppColors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Lottie.asset(
              'assets/lottie/lottie_success.json',
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            const AppText(text: 'is on it\'s way to:'),
            SizedBox(height: 20.h),
            AppText(
              text: "0x0E61830c8e35db159eF816868AfcA1388781796e",
              fontSize: 12.sp,
              color: const Color(0xff0d004c),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40.h),
            FilledButtons(
              text: 'Done',
              color: AppColors.secondaryColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
