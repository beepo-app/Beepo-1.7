import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/providers/update_active_time.dart';
import 'package:Beepo/providers/claim_daily_points_provider.dart';
import 'package:Beepo/providers/total_points_provider.dart';
import 'package:Beepo/providers/updated_points_provider.dart';
import 'package:Beepo/providers/withdraw_points_provider.dart';
import 'package:Beepo/providers/update_referral_provider.dart';
import 'package:Beepo/widgets/activity_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ActivityHubScreen extends StatefulWidget {
  const ActivityHubScreen({super.key});

  @override
  State<ActivityHubScreen> createState() => _ActivityHubScreenState();
}

class _ActivityHubScreenState extends State<ActivityHubScreen> {
  @override
  void initState() {
    ClaimDailyPointsProvider().loadFromHive();
    WithDrawPointsProvider().loadFromHive();
    UpdateReferralProvider().init();
    UpdatedPointsProvider().loadFromHive();
    UpdateActiveTimeProvider().initActivityTimer();
    TotalPointProvider().rankEntry;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dailyProvider = Provider.of<ClaimDailyPointsProvider>(context);
    final withDrawPointProvider = Provider.of<WithDrawPointsProvider>(context);
    final pointProvider = Provider.of<UpdatedPointsProvider>(context);
    final totalPointEarn = Provider.of<TotalPointProvider>(context);
    final activeTimeProvider = Provider.of<UpdateActiveTimeProvider>(context);

    final referralTotalProvider = Provider.of<UpdateReferralProvider>(context);

    final accountProvider = Provider.of<AccountProvider>(context, listen: true);
    final username = accountProvider.username;

    String getReferralLink(String? username) {
      return 'https://play.google.com/store/apps/details?id=com.beepo.app&referrer=$username';
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text(
          'Activity Hub',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {},
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0e014C),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                color: const Color.fromRGBO(241, 240, 240, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 20, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromRGBO(231, 231, 231, 1)),
                            child: Icon(
                              totalPointEarn.rankEntry.value,
                              color: const Color.fromRGBO(250, 145, 8, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Beeper Rank',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                totalPointEarn.rankEntry.key,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Iconsax.info_circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: const Color.fromRGBO(241, 240, 240, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 20, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromRGBO(231, 231, 231, 1)),
                            child: const Icon(
                              Iconsax.user_add,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Referrals',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                '${referralTotalProvider.referrals}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(250, 145, 8, 1),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (username != null) {
                                String referralLink = getReferralLink(username);
                                Clipboard.setData(
                                    ClipboardData(text: referralLink));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Referral link copied!')),
                                );
                                await referralTotalProvider
                                    .updateReferrals(referralLink);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Username is null!'),
                                ));
                              }
                            },
                            icon: const Icon(
                              Iconsax.copy,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              getReferralLink(username);
                            },
                            icon: const Icon(
                              Iconsax.global,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: const Color.fromRGBO(241, 240, 240, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 20, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: const Color.fromRGBO(231, 231, 231, 1)),
                            child: const Icon(
                              Iconsax.award,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Beep Points Earned',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                "Total Points: ${dailyProvider.points + withDrawPointProvider.points + pointProvider.points}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(250, 145, 8, 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0xffD9D9D9),
                            foregroundColor: const Color(0xff263238),
                            fixedSize: const Size(120, 1),
                          ),
                          onPressed: null,
                          // withDrawPointProvider.isLoading
                          //     ? null
                          //     : () => withDrawPointProvider.withdrawPoints(
                          //         accountProvider.ethAddress.toString()),
                          child: withDrawPointProvider.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Withdraw'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                color: const Color.fromRGBO(241, 240, 240, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 20, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromRGBO(231, 231, 231, 1),
                            ),
                            child: const Icon(
                              Iconsax.clock,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Daily Login Point: ${dailyProvider.points}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff0e014C),
                            ),
                          ),
                        ],
                      ),
                      dailyProvider.canClaim
                          ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: const Color(0xffD9D9D9),
                                foregroundColor: const Color(0xff263238),
                                fixedSize: const Size(120, 1),
                              ),
                              onPressed: dailyProvider.isLoading
                                  ? null
                                  : () => dailyProvider.claimPoints(
                                      accountProvider.ethAddress.toString()),
                              child: dailyProvider.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.0),
                                    )
                                  : const Text('Claim'),
                            )
                          : Text(
                              'Next claim in ${dailyProvider.nextClaimTime.difference(DateTime.now()).inHours} hours',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'Featured Tasks',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff0E014C),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ActivityButton(
                checkStatus: true,
                mytext: 'Send 100 messages',
                buttontext: '100p',
                press: () {},
                icon: Iconsax.send_1,
              ),
              const SizedBox(
                height: 10,
              ),
              ActivityButton(
                checkStatus: false,
                mytext: 'Stay active for 3hrs',
                buttontext: activeTimeProvider.points.toString(),
                icon: Iconsax.tick_circle,
              ),
              const SizedBox(
                height: 10,
              ),
              ActivityButton(
                checkStatus: true,
                mytext: 'Daily Moment Point',
                buttontext: '50p',
                press: () {},
                icon: Iconsax.status_up,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
