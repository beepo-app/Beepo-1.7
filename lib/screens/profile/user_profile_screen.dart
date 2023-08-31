import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff0e014c),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
              color: AppColors.white,
            ),
            onPressed: () {}),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: AppColors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 200.h,
              width: double.infinity,
              color: const Color(0xff0e014c),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 45.h,
                    child: Icon(
                      Icons.person,
                      size: 70.r,
                      color: AppColors.borderGrey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AppText(
                    text: "Sylvia Chirah",
                    fontSize: 20.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 2.h),
                  AppText(
                    text: "Sylvia Chirah",
                    fontSize: 10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w200,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Iconsax.message_2,
                              size: 35,
                              color: Color(0xffFF9C34),
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(height: 2.h),
                          const Text(
                            "Message",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        children: [
                          SvgPicture.asset('assets/block.svg'),
                          SizedBox(height: 6.h),
                          const Text(
                            "Block",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AppText(
                        text:
                            "Hi there, am a blockchain developer \nbut i sell shoes, WAGMI😍 Buy my Shoes",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                        color: const Color(0xff0e014c),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Mute notifications",
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff0e014c),
                          fontSize: 14.sp,
                        ),
                        Switch(
                          value: isSwitch,
                          activeColor: AppColors.black,
                          onChanged: (value) {
                            setState(() {
                              isSwitch = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Joined since:",
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff0e014c),
                          fontSize: 14.sp,
                        ),
                        const AppText(
                          text: "july 6th 2023",
                          color: Color(0xff0e014c),
                        )
                      ],
                    ),
                    SizedBox(height: 15.h),
                    const Divider(),
                    AppText(
                      text: "Mutual Groups",
                      fontWeight: FontWeight.w900,
                      color: const Color(0xff0e014c),
                      fontSize: 14.sp,
                    ),
                    SizedBox(height: 25.h),
                    Center(
                      child: AppText(
                        text: "You do not have any mutual group",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff0e014c),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
