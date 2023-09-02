import 'package:beepo/components/filled_button.dart';
import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utils/styles.dart';

class SendToken extends StatefulWidget {
  const SendToken({
    Key? key,
  }) : super(key: key);

  @override
  State<SendToken> createState() => _SendTokenState();
}

class _SendTokenState extends State<SendToken> {
  final TextEditingController amount = TextEditingController();
  final TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15.r)),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        centerTitle: true,
        backgroundColor: const Color(0xe50d004c),
        title: AppText(
          text: "Send Token",
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Amount",
                  style: TextStyle(
                    color: Color(0xe50d004c),
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Color(0xff0d004c),
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
                    child: AppText(
                      text: "SOL",
                      fontSize: 16.sp,
                      color: AppColors.textGrey,
                    ),
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    borderSide: const BorderSide(width: 1, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Address",
                  style: TextStyle(
                    color: Color(0xe50d004c),
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: address,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: IconButton(
                    onPressed: () async {},
                    icon: const Icon(
                      Icons.qr_code_scanner_sharp,
                      size: 25,
                      color: Color(0x7f0e014c),
                    ),
                  ),
                  hintText: "Enter Address",
                  hintStyle: TextStyle(
                    color: const Color(0x7f0e014c),
                    fontSize: 13.sp,
                  ),
                  border: border,
                  focusedBorder: border,
                ),
              ),
              SizedBox(height: 30.h),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        text: "Send to contacts",
                        fontSize: 14.sp,
                        color: const Color(0x7f0e014c),
                        fontWeight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: AppText(
                          text: "View more >",
                          fontSize: 11.sp,
                          color: const Color(0x7f0e014c),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 12.h),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  shrinkWrap: true,
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (ctx, i) => const SizedBox(width: 10),
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.r),
                          child: Image.asset(
                            'assets/profile_img.png',
                            height: 50.h,
                            width: 50.h,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          "James",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              BeepoFilledButtons(
                text: 'complete',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
