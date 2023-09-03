import 'package:beepo/components/filled_button.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:beepo/widgets/beepo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/constants.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        centerTitle: true,
        backgroundColor: AppColors.secondaryColor,
        title: AppText(
          text: "Edit Profile",
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
          color: AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: AppColors.chipBgGrey,
                    ),
                    Positioned(
                      bottom: 12.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              AppText(
                text: "Display name",
                color: AppColors.secondaryColor,
                fontSize: 16.sp,
              ),
              AppText(
                text: "Your display name can only be edit once in 30days",
                color: AppColors.secondaryColor,
                fontSize: 10.sp,
              ),
              SizedBox(height: 10.h),
              BeepoTextField(
                hintText: 'Enter your display name',
                controller: displayNameController,
              ),
              SizedBox(height: 20.h),
              AppText(
                text: "Username",
                color: AppColors.secondaryColor,
                fontSize: 16.sp,
              ),
              AppText(
                text: "Your username can only be edit once in every 6months",
                color: AppColors.secondaryColor,
                fontSize: 10.sp,
              ),
              SizedBox(height: 10.h),
              BeepoTextField(
                hintText: 'Enter your username',
                controller: userNameController,
              ),
              SizedBox(height: 20.h),
              AppText(
                text: "Bio",
                color: AppColors.secondaryColor,
                fontSize: 16.sp,
              ),
              AppText(
                text: "Max 100 Characters",
                color: AppColors.secondaryColor,
                fontSize: 10.sp,
              ),
              SizedBox(height: 10.h),
              BeepoTextField(
                hintText: 'Enter your username',
                controller: bioController,
              ),
              SizedBox(height: 35.h),
              Center(
                child: BeepoFilledButtons(
                  text: "Save",
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
