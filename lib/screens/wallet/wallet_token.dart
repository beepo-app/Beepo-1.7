import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WalletToken extends StatefulWidget {
  const WalletToken({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletToken> createState() => _WalletTokenState();
}

class _WalletTokenState extends State<WalletToken> {
  bool isPositive = false;
  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text(
                  '\$54.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  "1.87",
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.secondaryColor,
              ),
              child: Column(children: [
                const SizedBox(height: 75),
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: AppColors.backgroundGrey,
                ),
                const SizedBox(height: 8),
                AppText(
                  text: "35.4789 CELO",
                  fontSize: 20.sp,
                  color: AppColors.white,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        Transform.rotate(
                          angle: 24.5,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send_outlined,
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          text: "Send",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.file_download_sharp,
                            size: 20,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        AppText(
                          text: "Receive",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                    const SizedBox(),
                  ],
                ),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(
              Icons.qr_code_scanner,
              size: 40,
              color: AppColors.secondaryColor,
            ),
            title: AppText(
              text: "Your address",
              fontSize: 14.sp,
              color: AppColors.secondaryColor,
            ),
            subtitle: AppText(
              text: "wallet address",
              fontSize: 12.sp,
              color: AppColors.secondaryColor,
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.copy_outlined,
                size: 30,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
          const Divider(
            height: 2,
            thickness: 2,
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: 4,
              itemBuilder: (ctx, i) {
                return ListTile(
                  minLeadingWidth: 10,
                  leading: Icon(
                    isSent ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: isSent ? Colors.red : Colors.green,
                  ),
                  onTap: () {},
                  title: Row(
                    children: [
                      Expanded(
                        child: AppText(
                          text: "Deposit",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      AppText(
                        text: "+0.23 CELO",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSent ? Colors.red : Colors.green,
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          isSent
                              ? "To: From: 0x0G61836c8e35db159eG816868AfcA1388781856j"
                              : "From: From: 0x0G61836c8e35db159eG816868AfcA1388781856j",
                          style: const TextStyle(
                            color: Color(0x7f0e014c),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "${DateTime.now()}",
                        style: TextStyle(
                          color: const Color(0x7f0e014c),
                          fontSize: 7.sp,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}
