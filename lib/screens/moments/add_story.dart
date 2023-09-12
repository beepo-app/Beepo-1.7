import 'package:beepo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/app_text.dart';

class AddStory extends StatelessWidget {
  const AddStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.black,
      ),
      bottomNavigationBar: Column(
        children: [
          Expanded(
            child: Container(
              color: AppColors.black,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 8.h),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Container(
                          height: 30.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 70.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFE6E9EE),
                            border: Border.all(color: Colors.orange, width: 2),
                            // borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset('assets/Rotate.svg'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              onLongPress: () {},
              child: const AppText(
                text: "  Tap for photos, hold for videos",
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
