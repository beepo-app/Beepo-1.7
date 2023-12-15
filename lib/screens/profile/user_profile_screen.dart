import 'dart:convert';

import 'package:Beepo/components/Beepo_filled_button.dart';
import 'package:Beepo/constants/constants.dart';
import 'package:Beepo/screens/messaging/chats/chat_tab.dart';
import 'package:Beepo/widgets/app_text.dart';
import 'package:Beepo/widgets/cache_memory_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileScreen extends StatefulWidget {
  final Map? user;
  const UserProfileScreen({super.key, this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool isSwitch = false;

  @override
  Widget build(BuildContext context) {
    var user = widget.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
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
              width: double.infinity,
              color: const Color(0xff0e014c),
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: CacheMemoryImageProvider(user!['image'], base64Decode(user['image'])),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  AppText(
                    text: user['displayName'],
                    fontSize: 20.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 2.h),
                  AppText(
                    text: "@${user['username']}",
                    fontSize: 10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w200,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Iconsax.message_2,
                              size: 35,
                              color: Color(0xffFF9C34),
                            ),
                            onPressed: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   // return const ChatDmScreen();
                              // }));
                            },
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
                          InkWell(
                            child: SvgPicture.asset('assets/block.svg'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Hey Beeper, please be aware that once that triggered, this action is irreversible.",
                                            style: TextStyle(
                                              color: AppColors.secondaryColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10.h),
                                          const Text(
                                            "Are you certain you want to block this user?",
                                            style: TextStyle(
                                              color: AppColors.secondaryColor,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 15.h),
                                          BeepoFilledButtons(
                                            text: 'Block',
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) {
                                                  return const ChatTab();
                                                }),
                                              );
                                            },
                                            color: AppColors.secondaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
                        text: user['bio'] ?? 'No Bio Available',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                        color: const Color(0xff0e014c),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    const Divider(),
                    SizedBox(height: 10.h),
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
