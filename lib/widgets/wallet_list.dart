import 'package:beepo/constants/constants.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletList extends StatefulWidget {
  const WalletList({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletList> createState() => _WalletListState();
}

class _WalletListState extends State<WalletList> {
  bool isColor = false;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      separatorBuilder: (_, int index) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (_, int index) {
        return Card(
          color: AppColors.white,
          child: ListTile(
            leading: Image.asset(AppImages.bCoin),
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
                      color: isColor
                          ? AppColors.activeTextColor
                          : AppColors.favouriteButtonRed,
                    ),
                  ],
                ),
                const AppText(text: "\$622.43"),
              ],
            ),
          ),
        );
      },
    );
  }
}
