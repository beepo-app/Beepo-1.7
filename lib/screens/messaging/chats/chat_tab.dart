import 'package:beepo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24.w, right: 15.w, top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Messages",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: AppColors.secondaryColor,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.more_vert_outlined,
                      color: AppColors.secondaryColor,
                      size: 18.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ListTile(
                    leading: Container(
                      height: 50.h,
                      width: 50.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Precious",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "9.13",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      "Hey Buddy, got the contract ready for deployment yet?",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryColor,
        onPressed: () {},
        child: const Icon(
          Icons.menu,
          color: AppColors.white,
        ),
      ),
    );
  }
}
