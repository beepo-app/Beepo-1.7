import 'package:beepo/Screens/Auth/create_acct.dart';
import 'package:beepo/Screens/Auth/login_screen.dart';
import 'package:beepo/components/filled_button.dart';
import 'package:beepo/components/outline_button.dart';
import 'package:flutter/material.dart';
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/login.png',
                height: 252,
                width: 252,
              ),
              const Spacer(),
              FilledButtons(
                text: 'Create Account',
                onPressed: () => Get.to(CreateAccount()),
              ),
              const SizedBox(height: 35),
              FilledButtons(
                text: 'Import Wallet',
                onPressed: () => Get.to(CreateAccount()),
              ),
              const SizedBox(height: 35),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  width: 70,
                  height: 1,
                  color: Colors.black,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "or",
                    style: TextStyle(
                      color: Color(0x4c0e014c),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 70, // Width of the line
                  height: 1, // Height of the line (thickness)
                  color: Colors.black, // Color of the line
                ),
              ]),
              const SizedBox(height: 12),
              OutlnButton(
                text: 'Continue with Google',
                onPressed: () => Get.to(const Login()),
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
