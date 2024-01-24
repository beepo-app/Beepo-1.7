import 'package:Beepo/constants/constants.dart';
import 'package:Beepo/providers/wallet_provider.dart';
import 'package:Beepo/screens/profile/profile_screen.dart';
import 'package:Beepo/screens/wallet/phrase_confirm_screen.dart';
import 'package:Beepo/widgets/app_text.dart';
import 'package:Beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class UserProfileSecurityScreen extends StatefulWidget {
  const UserProfileSecurityScreen({super.key});

  @override
  State<UserProfileSecurityScreen> createState() => _UserProfileSecurityScreenState();
}

class _UserProfileSecurityScreenState extends State<UserProfileSecurityScreen> {
  bool isLoginWithBioSwitch = Hive.box('Beepo2.0').get('isLoginWithBioSwitch') ?? false;
  bool isAutoLockSwitch = Hive.box('Beepo2.0').get('isAutoLockSwitch') ?? false;

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        toolbarHeight: 45.h,
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
                  fontSize: 12.sp,
                ),
                SizedBox(
                  width: 42,
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: isLoginWithBioSwitch,
                      activeColor: AppColors.black,
                      onChanged: (value) {
                        Hive.box('Beepo2.0').put('isLoginWithBioSwitch', value);

                        setState(() {
                          isLoginWithBioSwitch = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Auto Lock",
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff0e014c),
                  fontSize: 12.sp,
                ),
                SizedBox(
                  width: 42,
                  height: 35,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Switch(
                      value: isAutoLockSwitch,
                      activeColor: AppColors.black,
                      onChanged: (value) {
                        Hive.box('Beepo2.0').put('isAutoLockSwitch', value);
                        setState(() {
                          isAutoLockSwitch = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PhraseConfirmationScreen();
                }));
              },
              child: walletProvider.mnemonic != null
                  ? AppText(
                      text: "Seed Phrase",
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff0e014c),
                      fontSize: 12.sp,
                    )
                  : const AppText(text: ''),
            ),
          ],
        ),
      ),
    );
  }
}
