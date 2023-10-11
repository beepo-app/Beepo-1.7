import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/screens/wallet/wallet_token_screen.dart';
import 'package:beepo/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WalletList extends StatefulWidget {
  const WalletList({
    Key? key,
  }) : super(key: key);

  @override
  State<WalletList> createState() => _WalletListState();
}

class _WalletListState extends State<WalletList> {
  bool isColor = false;
  bool isFetched = false;
  List<dynamic>? assets;

  getAssests() async {
    try {
      final walletProvider = Provider.of<WalletProvider>(context, listen: false);
      List<dynamic>? assets_ = walletProvider.assets;
      setState(() {
        if (assets_ != null) {
          assets = assets_;
          isFetched = true;
        }
      });
      await walletProvider.getAssets();
      var asset = walletProvider.assets;
      print(asset);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    getAssests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return assets == null
        ? const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          )
        : ListView.separated(
            itemCount: assets!.length,
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
                      return WalletTokenScreen(data: assets![index]);
                    }));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(assets![index]['logoUrl']),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(text: assets![index]['displayName']),
                      AppText(text: assets![index]['bal']),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AppText(text: '\$${assets![index]['current_price'].toString()}'),
                          SizedBox(width: 8.w),
                          AppText(
                            text: '${assets![index]['24h_price_change'].toString()}%',
                            color: assets![index]['24h_price_change'] > 0 ? AppColors.activeTextColor : AppColors.favouriteButtonRed,
                          ),
                        ],
                      ),
                      AppText(text: "\$${assets![index]['bal_to_price'].toString()}"),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
