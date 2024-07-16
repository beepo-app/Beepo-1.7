import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/providers/point_provider.dart';
import 'package:Beepo/widgets/activity_button.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityHubScreenState();
}

class _ActivityHubScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final activityPoints = Provider.of<ActivityPoints>(context, listen: false);
    final accountProvider = Provider.of<AccountProvider>(context, listen: true);

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
                            child: const Icon(
                              Icons.cabin,
                              color: Color.fromRGBO(250, 145, 8, 1),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Beeper Rank',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                "Novice",
                                style: TextStyle(
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
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Referrals',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                '10',
                                style: TextStyle(
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
                            onPressed: () async {},
                            icon: const Icon(
                              Iconsax.copy,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {},
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
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Beep Points Earned',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff0e014C),
                                ),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                "Total Points",
                                style: TextStyle(
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
                          child: const Text('Withdraw'),
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
                            'Daily Login Point: ${activityPoints.claimDailyPoints(accountProvider.ethAddress.toString())}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff0e014C),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xffD9D9D9),
                          foregroundColor: const Color(0xff263238),
                          fixedSize: const Size(120, 1),
                        ),
                        onPressed: activityPoints.isLoading
                            ? null
                            : () async {
                                await activityPoints.claimDailyPoints(
                                    accountProvider.ethAddress.toString());
                              },
                        child: activityPoints.isLoading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.grey),
                              )
                            : const Text(
                                'Claim',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                      )
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
              const ActivityButton(
                checkStatus: false,
                mytext: 'Stay active for 3hrs',
                buttontext: "50",
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
