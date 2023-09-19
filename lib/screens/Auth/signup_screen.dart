import 'package:beepo/components/beepo_filled_button.dart';
import 'package:beepo/components/outline_button.dart';
import 'package:beepo/screens/auth/create_acct_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const Spacer(),
              Image.asset(
                'assets/login.png',
                height: 250.h,
                width: 250.w,
              ),
              // const Spacer(),
              BeepoFilledButtons(
                text: 'Create Account',
                onPressed: () => Get.to(() => const CreateAccountScreen()),
              ),
              SizedBox(height: 33.h),
              BeepoFilledButtons(
                text: 'Import Wallet',
                onPressed: () {},
              ),
              SizedBox(height: 33.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 70,
                  height: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "or",
                    style: TextStyle(
                      color: const Color(0x4c0e014c),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 70,
                  height: 1,
                  color: Colors.black,
                ),
              ]),
              SizedBox(height: 10.h),
              OutlnButton(
                text: 'Continue with Google',
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const Login(),
                  //   ),
                  // );
                },
              ),
              // SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }
}
