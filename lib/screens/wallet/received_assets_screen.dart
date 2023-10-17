import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/wallet/token_screen_scan.dart';
import 'package:beepo/screens/wallet/wallet_screen.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:beepo/widgets/beepo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReceivedAssetScreen extends StatefulWidget {
  final List<dynamic> assets_;
  const ReceivedAssetScreen({
    required this.assets_,
    Key? key,
  }) : super(key: key);
  @override
  State<ReceivedAssetScreen> createState() => _ReceivedAssetScreenState();
}

class _ReceivedAssetScreenState extends State<ReceivedAssetScreen> {
  bool isColor = false;

  @override
  Widget build(BuildContext context) {
    List<dynamic> assets = widget.assets_;
    print(assets);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60.h,
        backgroundColor: AppColors.secondaryColor,
        title: Column(
          children: [
            AppText(
              text: "Receive Token",
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            SizedBox(height: 2.h),
            AppText(
              text: "Choose asset",
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        child: Column(
          children: [
            const BeepoTextField(
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.borderGrey,
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ListView.separated(
                itemCount: assets.length,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                separatorBuilder: (_, int index) {
                  return const SizedBox(height: 20);
                },
                itemBuilder: (_, int index) {
                  return Material(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    color: AppColors.white,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const TokenScreenScan();
                        }));
                      },
                      leading: Image.network(assets[index]['logoUrl']),
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(text: "Bitcoin"),
                          AppText(text: "\$622.43"),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const AppText(text: "\$30,396"),
                              SizedBox(width: 8.w),
                              AppText(
                                text: "+1.97",
                                color: isColor ? AppColors.activeTextColor : AppColors.favouriteButtonRed,
                              ),
                            ],
                          ),
                          const AppText(text: "\$622.43"),
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
