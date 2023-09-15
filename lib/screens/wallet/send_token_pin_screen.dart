import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/wallet/transfer_success.dart';
import 'package:beepo/utils/styles.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SendTokenPinScreen extends StatefulWidget {
  const SendTokenPinScreen({super.key});

  @override
  State<SendTokenPinScreen> createState() => _SendTokenPinScreenState();
}

class _SendTokenPinScreenState extends State<SendTokenPinScreen> {
  TextEditingController otp = TextEditingController();

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
              text: "1 BNB",
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
            SizedBox(height: 40.h),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
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
                onChanged: (val) {
                  if (otp.text.length == 4) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const TransferSuccess();
                    }));
                  }
                  ;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
