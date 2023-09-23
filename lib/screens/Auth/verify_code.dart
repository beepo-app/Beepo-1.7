import 'dart:convert';
import 'dart:io';
import 'package:beepo/components/beepo_filled_button.dart';
import 'package:beepo/components/bottom_nav.dart';
import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/services/encryption.dart';
import 'package:beepo/utils/styles.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class VerifyCode extends StatefulWidget {
  final File image;
  final String name;
  final String pin;
  const VerifyCode(
      {key, required this.image, required this.name, required this.pin})
      : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          //size: 30.0,
          onPressed: () {},
        ),
        title: const Text(
          "Verify your PIN",
          style: TextStyle(
            color: Color(0xb20e014c),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/pin_img.png',
              height: 127,
              width: 127,
            ),
            const SizedBox(height: 70),
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
                onChanged: (val) {},
              ),
            ),
            const Spacer(),
            const Spacer(),
            BeepoFilledButtons(
              text: 'Continue',
              onPressed: () async {
                print(widget.pin);
                if (widget.pin == otp.text) {
                  final walletProvider =
                      Provider.of<WalletProvider>(context, listen: false);
                  final accountProvider =
                      Provider.of<AccountProvider>(context, listen: false);
                  final xmtpProvider =
                      Provider.of<XMTPProvider>(context, listen: false);

                  String mnemonic = walletProvider.generateMnemonic();
                  String padding = "000000000000";
                  Encrypted encrypteData =
                      encryptWithAES('${otp.text}$padding', mnemonic);

                  await walletProvider.initWalletState(mnemonic);

                  EthereumAddress? ethAddress = walletProvider.address;
                  List<int> imageBytes = await widget.image.readAsBytes();
                  String base64Image = base64Encode(imageBytes);

                  if (ethAddress != null && accountProvider.db != null) {
                    try {
                      await accountProvider.createUser(
                        base64Image,
                        accountProvider.db,
                        widget.name,
                        ethAddress.toString(),
                        encrypteData,
                      );

                      await xmtpProvider.initClient(walletProvider.privateKey!);
                    } catch (e) {
                      if (kDebugMode) {
                        print(e.toString());
                      }
                    }
                  }

                  Get.to(
                    () => const BottomNavHome(),
                  );
                }
              },
            ),
            const SizedBox(height: 40, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
