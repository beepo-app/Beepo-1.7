import 'package:beepo/components/beepo_filled_button.dart';
import 'package:beepo/screens/Auth/pin_code.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phraseController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () {},
        ),
        foregroundColor: Colors.black,
        title: const Text(
          "Enter your secret phrase below to login",
          style: TextStyle(
            color: Color(0xb20e014c),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: const Text('Phrase'),
            ),
            TextField(
              controller: phraseController,
              minLines: 5,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Enter your secret phrase',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 7.h),
            const Text(
              "This is usually a 12 word phrase",
              style: TextStyle(
                color: Color(0x4c0e014c),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            BeepoFilledButtons(
              text: 'Login',
              onPressed: () async {
                String phrase = phraseController.text.trim();
                if (phrase.isEmpty) {
                  showToast('Please enter your secret phrase');
                } else {
                  // Get.to(
                  //   fullScreenLoader('Verifying Seedphrase...'),
                  //   fullscreenDialog: true,
                  // );
                  // bool result = await AuthService().loginWithSecretPhrase(phrase);
                  // AuthService().verifyPhrase(phrase);
                  Get.to(() => const PinCode(
                        isSignUp: false,
                      ));

                  // Get.back();
                  // if (result) {
                  //   showToast('Logged in successfully');
                  // } else {
                  //   showToast('Something went wrong');
                  // }
                }
              },
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}
