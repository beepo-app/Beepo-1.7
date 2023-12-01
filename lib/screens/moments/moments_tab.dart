import 'package:Beepo/constants/constants.dart';
import 'package:Beepo/screens/moments/moments_screen.dart';
import 'package:Beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MomentsTab extends StatefulWidget {
  const MomentsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<MomentsTab> createState() => _MomentsTabState();
}

class _MomentsTabState extends State<MomentsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Explore Moments",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    AppText(
                      text: "latests",
                      color: AppColors.black,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.sort,
                      size: 15.sp,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: GridView.builder(
                itemCount: 10,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 175.h,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (BuildContext context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const MomentsScreens();
                      }));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.greyBoxBg,
                        image: const DecorationImage(
                          image: AssetImage("assets/mBg.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            // height: 40.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.only(
                                bottomLeft: const Radius.circular(10),
                                bottomRight: Radius.circular(10.r),
                                topLeft: const Radius.circular(0),
                                topRight: const Radius.circular(0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 15.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20.r,
                                    backgroundColor: AppColors.white,
                                    backgroundImage: const AssetImage("assets/profile_img1.png"),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        text: "Andrey Hugh",
                                        fontSize: 12.sp,
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: AppColors.white,
                                          ),
                                          children: const [TextSpan(text: "11.1k "), TextSpan(text: "Views")],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
