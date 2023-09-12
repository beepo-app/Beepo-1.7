import 'package:beepo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ChatDmsScreen extends StatelessWidget {
  const ChatDmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
        toolbarHeight: 60.h,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.backgroundGrey,
            ),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sylvia Chirah",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  "@sylvia",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_outlined,
              color: AppColors.white,
              size: 18.sp,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 20, right: 20),
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      top: 20,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.chatcolor,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(3, 3),
                            spreadRadius: 2,
                            color: AppColors.greyBoxBg.withOpacity(0.5),
                          ),
                        ],
                      ),
                      child: Text(
                        "Hi, developer how are you",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50, top: 10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 15, right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(3, 3),
                              spreadRadius: 2,
                              color: AppColors.chatcolor,
                            ),
                          ],
                        ),
                        child: Text(
                          "Hello programmer, i am fine thanks for asking what about you, i hope you will be fine",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        height: 50.h,
        color: Colors.grey.shade100,
        child: Padding(
          padding: EdgeInsets.only(bottom: 7.h, right: 6.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textGrey,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                    filled: true,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Message",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.dividerGrey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Iconsax.dollar_circle,
                        size: 23.sp,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  size: 30.sp,
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
