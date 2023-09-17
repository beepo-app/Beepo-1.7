import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferInfo extends StatelessWidget {
  final String? walletTicker;
  const TransferInfo({Key? key, this.walletTicker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 7, right: 25),
                    height: 90.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xff0e014c),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_outlined,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                            AppText(
                              text: "Transfer",
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            AppText(
              text: "-0.06171059372171178 ETH",
              fontWeight: FontWeight.w900,
              color: Colors.red,
              fontSize: 20.sp,
            ),
            SizedBox(height: 5.h),
            AppText(
              text: "113,96",
              fontWeight: FontWeight.w900,
              color: AppColors.textGrey,
              fontSize: 14.sp,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Date",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                  ),
                  AppText(
                    text: "2-19-2023 18:12",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Status",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                  ),
                  AppText(
                    text: "Completed",
                    fontWeight: FontWeight.w900,
                    color: Colors.green.shade500,
                    fontSize: 14.sp,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Transaction Type",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                  ),
                  AppText(
                    text: "Internal",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                children: [
                  AppText(
                    text: "Recipient",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    fontSize: 14.sp,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: AppText(
                      text: " Get username",
                      fontWeight: FontWeight.w900,
                      color: AppColors.textGrey,
                      textAlign: TextAlign.right,
                      fontSize: 14.sp,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: "Network Fee",
                    fontWeight: FontWeight.w900,
                    color: AppColors.textGrey,
                    textAlign: TextAlign.right,
                    fontSize: 14.sp,
                  ),
                  const Spacer(),
                  Expanded(
                    child: AppText(
                      text: "0.000333492745005 ETH 0.56",
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey,
                      textAlign: TextAlign.right,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              child: AppText(
                text: "More Details",
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
