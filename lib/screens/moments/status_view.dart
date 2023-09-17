import 'package:beepo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.white),
    );
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/mBg.jpg",
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FittedBox(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.secondaryColor,
                      ),
                      decoration: InputDecoration(
                        fillColor: AppColors.white,
                        filled: true,
                        border: border,
                        focusedBorder: border,
                        enabledBorder: border,
                        contentPadding: const EdgeInsets.all(18),
                        hintText: "Type message...",
                        hintStyle: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: 30.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.secondaryColor,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
