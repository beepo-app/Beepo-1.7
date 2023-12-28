import 'dart:convert';

import 'package:Beepo/components/bottom_nav.dart';
import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/providers/auth_provider.dart';
import 'package:Beepo/providers/wallet_provider.dart';
import 'package:Beepo/session/foreground_session.dart';
import 'package:Beepo/widgets/commons.dart';
import 'package:Beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:xmtp/xmtp.dart';

import '../../Utils/styles.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    // final xmtpProvider = Provider.of<XMTPProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Image.asset(
              'assets/logo2.png',
              height: 127,
              width: 127,
            ),
            const SizedBox(height: 70),
            const Text(
              'Enter your PIN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: Get.size.width * 0.6,
              child: PinCodeTextField(
                appContext: context,
                keyboardType: TextInputType.number,
                length: 4,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: false,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  fieldHeight: 30,
                  fieldWidth: 30,
                  activeColor: primaryColor,
                  inactiveFillColor: Colors.white,
                  inactiveColor: Colors.grey,
                  borderWidth: 3,
                  fieldOuterPadding: EdgeInsets.zero,
                  activeFillColor: Colors.white,
                  selectedColor: primaryColor,
                  selectedFillColor: Colors.white,
                ),
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: otp,
                onCompleted: (v) {},
                onChanged: (String value) async {
                  if (value.length == 4) {
                    String response = await login(value);
                    if (response.contains("Incorrect Pin Entered")) {
                      showToast("Incorrect Pin Entered");
                      return;
                    }
                    fullScreenLoader("Logging In!");

                    if (response.contains('privKey')) {
                      Map data = jsonDecode(response);
                      await walletProvider.initMPCWalletState(data);
                      await accountProvider.initAccountState();
                      EthPrivateKey credentials = EthPrivateKey.fromHex(walletProvider.ethPrivateKey!);
                      if (session.initialized == false) {
                        await session.authorize(credentials.asSigner());
                      }

                      Future.delayed(const Duration(seconds: 3));
                      Get.to(
                        () => const BottomNavHome(),
                      );
                      return;
                    }

                    await walletProvider.initWalletState(response);
                    EthPrivateKey credentials = EthPrivateKey.fromHex(walletProvider.ethPrivateKey!);

                    if (session.initialized == false) {
                      await session.authorize(credentials.asSigner());
                    }
                    //await session.authorize(credentials.asSigner());
                    await accountProvider.initAccountState();

                    Get.to(
                      () => const BottomNavHome(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 40, width: double.infinity),
            const Text(
              'Or use biometrics',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.fingerprint,
                  size: 40,
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
