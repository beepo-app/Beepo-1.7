import 'package:beepo/screens/Auth/pin_code.dart';
import 'package:beepo/components/filled_button.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phraseController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_left,
            size: 30.0,
          ),
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
            const SizedBox(height: 8),
            const Text(
              "This is usually a 12 word phrase",
              style: TextStyle(
                color: Color(0x4c0e014c),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            FilledButtons(
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
                  Get.to(PinCode(
                    isSignUp: false,
                    seedPhrase: phrase,
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
