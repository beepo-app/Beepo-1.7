import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:beepo/widgets/wallet_icon.dart';
import 'package:beepo/widgets/wallet_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Utils/styles.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List<Map> currencies = [];
  String selectedCurrency = 'usd';
  String selectedCurrencySymbol = '\$';

  final List<PopupMenuEntry<String>> items = [
    const PopupMenuItem<String>(
      value: 'option1',
      child: Text('Option 1'),
    ),
    const PopupMenuItem<String>(
      value: 'option2',
      child: Text('Option 2'),
    ),
    const PopupMenuItem<String>(
      value: 'option3',
      child: Text('Option 3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 20.h,
            backgroundColor: Colors.white,
            actions: [
              PopupMenuButton<String>(
                itemBuilder: (context) {
                  return items;
                },
                onSelected: (value) {
                  // Handle menu item selection here
                  print('Selected: $value');
                },
              ),
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                AppText(
                  text: "Wallet",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppText(
                        text: "15,678.13",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                      const SizedBox(height: 11),
                      AppText(
                        text: "Total Balance",
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor,
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalletIcon(
                            text: 'Send',
                            icon: Icons.send_outlined,
                            angle: 5.7,
                            onTap: () {},
                          ),
                          WalletIcon(
                            text: 'Receive',
                            icon: Icons.file_download_sharp,
                            onTap: () {},
                          ),
                          WalletIcon(
                            text: 'Buy',
                            icon: Icons.shopping_cart_outlined,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(1.0),
                  child: TabBar(
                    indicatorColor: secondaryColor,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 2,
                    tabs: [
                      Tab(
                        child: AppText(
                          text: "Crypto Assets",
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Tab(
                        child: AppText(
                          text: "NFTs",
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: WalletList(),
                      ),
                      Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
