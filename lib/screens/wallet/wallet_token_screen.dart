import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/wallet/token_screen_scan.dart';
import 'package:beepo/screens/wallet/send_token_screen.dart';
import 'package:beepo/screens/wallet/transfer_info.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletTokenScreen extends StatefulWidget {
  final Map<String, dynamic>? data;
  const WalletTokenScreen({Key? key, this.data}) : super(key: key);

  @override
  State<WalletTokenScreen> createState() => _WalletTokenScreenState();
}

class _WalletTokenScreenState extends State<WalletTokenScreen> {
  bool isPositive = false;
  bool isSent = false;

  @override
  Widget build(BuildContext context) {
    print(widget.data);
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
                  backgroundImage: NetworkImage(widget.data!['logoUrl']),
                  backgroundColor: AppColors.backgroundGrey,
                ),
                const SizedBox(height: 8),
                AppText(
                  text: "${widget.data!['bal']} ${widget.data!['ticker']}",
                  fontSize: 20.sp,
                  color: AppColors.white,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(),
                    Column(
                      children: [
                        Transform.rotate(
                          angle: 24.5,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return const SendToken();
                              }));
                            },
                            icon: const Icon(
                              Icons.send_outlined,
                              size: 30,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return const TokenScreenScan();
                            }));
                          },
                          icon: const Icon(
                            Icons.file_download_sharp,
                            size: 30,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
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
              text: widget.data!['address'],
              fontSize: 12.sp,
              color: AppColors.secondaryColor,
            ),
            trailing: IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: widget.data!['address']));
                showToast('Address Copied To Clipboard!');
              },
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
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const TransferInfo();
                    }));
                  },
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
                          isSent ? "To: From: 0x0G61836c8e35db159eG816868AfcA1388781856j" : "From: From: 0x0G61836c8e35db159eG816868AfcA1388781856j",
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
