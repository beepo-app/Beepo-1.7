import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/screens/wallet/received_assets_screen.dart';
import 'package:beepo/screens/wallet/send_assets_screen.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:beepo/widgets/wallet_icon.dart';
import 'package:beepo/widgets/wallet_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
      value: 'USD',
      child: Text('USD'),
    ),
    // const PopupMenuItem<String>(
    //   value: 'option2',
    //   child: Text('Option 2'),
    // ),
    // const PopupMenuItem<String>(
    //   value: 'option3',
    //   child: Text('Option 3'),
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.add,
                color: AppColors.white,
              ),
            ),
            elevation: 0,
            toolbarHeight: 20.h,
            backgroundColor: AppColors.secondaryColor,
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
                SizedBox(height: 10.h),
                Text(
                  "Wallet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: AppColors.secondaryColor,
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "\$${walletProvider.totalBalance}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                          letterSpacing: 1,
                          color: AppColors.secondaryColor,
                        ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          WalletIcon(
                            text: 'Send',
                            icon: Icons.send_outlined,
                            angle: 5.7,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const SendAssetsScreen();
                              }));
                            },
                          ),
                          WalletIcon(
                            text: 'Receive',
                            icon: Icons.file_download_sharp,
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const ReceivedAssetScreen();
                              }));
                            },
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
                Padding(
                  padding: const EdgeInsets.all(1.0),
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
                          fontSize: 16.sp,
                        ),
                      ),
                      Tab(
                        child: AppText(
                          text: "NFTs",
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
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
