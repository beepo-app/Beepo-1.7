// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:beepo/components/filled_button.dart';
import 'package:flutter/material.dart';

class VerifyCode extends StatefulWidget {
  final File image;
  final String name;
  final String pin;
  const VerifyCode(
      {Key? key, required this.image, required this.name, required this.pin})
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
            const SizedBox(height: 100),
            Image.asset(
              'assets/pin_img.png',
              height: 127,
              width: 127,
            ),
            const SizedBox(height: 70),
            const Spacer(),
            BeepoFilledButtons(
              text: 'Continue',
              onPressed: () async {
// if(widget.pin == )
              },
            ),
            const SizedBox(height: 40, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
