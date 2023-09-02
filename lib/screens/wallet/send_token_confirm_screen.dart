import 'package:beepo/components/filled_button.dart';
import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendTokenConfirmScreen extends StatelessWidget {
  const SendTokenConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        backgroundColor: const Color(0xff0e014c),
        toolbarHeight: 75.h,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        title: Column(
          children: [
            SizedBox(height: 15.h),
            AppText(
              text: "Send Token",
              fontWeight: FontWeight.w900,
              fontSize: 25.sp,
              color: AppColors.white,
            ),
            AppText(
              text: "Confirm Transaction",
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: AppColors.white,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            AppText(
              text: "You are sending",
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 10.h),
            AppText(
              text: "50 SOL",
              fontSize: 19.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff0e014c),
            ),
            SizedBox(height: 10.h),
            AppText(
              text: "to the following wallet",
              fontSize: 14.sp,
              color: AppColors.textGrey,
            ),
            SizedBox(height: 10.h),
            Center(
              child: AppText(
                text: "0x0E61830c8e35db159eF816868AfcA1388781796e",
                fontSize: 12.sp,
                color: const Color(0xff0e014c),
              ),
            ),
            SizedBox(height: 50.h),
            AppText(
              text: "Gas Fee: 0.0098 SOL",
              fontSize: 14.sp,
              color: const Color(0xff0e014c),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 3),
            BeepoFilledButtons(
              text: "Approve",
              color: const Color(0xff0e014c),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
