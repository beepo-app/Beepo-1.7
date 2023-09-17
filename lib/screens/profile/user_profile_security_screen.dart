import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/profile/profile_screen.dart';
import 'package:beepo/screens/wallet/phrase_confirm_screen.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileSecurityScreen extends StatefulWidget {
  const UserProfileSecurityScreen({super.key});

  @override
  State<UserProfileSecurityScreen> createState() =>
      _UserProfileSecurityScreenState();
}

class _UserProfileSecurityScreenState extends State<UserProfileSecurityScreen> {
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ProfileScreen();
                },
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        toolbarHeight: 50.h,
        backgroundColor: AppColors.secondaryColor,
        title: AppText(
          text: "My Profile",
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          color: AppColors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: AppText(
                text: "Security",
                color: AppColors.secondaryColor,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Login with Biometrics",
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff0e014c),
                  fontSize: 14.sp,
                ),
                Switch(
                  value: isSwitch,
                  activeColor: AppColors.black,
                  onChanged: (value) {
                    setState(() {
                      isSwitch = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Auto Lock",
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff0e014c),
                  fontSize: 14.sp,
                ),
                Switch(
                  value: isSwitch,
                  activeColor: AppColors.black,
                  onChanged: (value) {
                    setState(() {
                      isSwitch = value;
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PhraseConfirmationScreen();
                    }));
                  },
                  child: AppText(
                    text: "Seed Phrase",
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff0e014c),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
