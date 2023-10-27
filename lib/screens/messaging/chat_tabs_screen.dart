import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/messaging/calls/calls_tab.dart';
import 'package:beepo/screens/messaging/chats/chat_tab.dart';
import 'package:beepo/screens/messaging/chats/search_users_screen.dart';
import 'package:beepo/screens/moments/moments_tab.dart';
import 'package:beepo/widgets/filled_buttons.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:iconsax/iconsax.dart';

import '../moments/add_story.dart';
import '../moments/moments_screen.dart';

class ChatTabsScreen extends StatefulWidget {
  const ChatTabsScreen({super.key});

  @override
  State<ChatTabsScreen> createState() => _ChatTabsScreenState();
}

class _ChatTabsScreenState extends State<ChatTabsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HawkFabMenu(
        icon: AnimatedIcons.menu_close,
        fabColor: const Color(0xe50d004c),
        items: [
          HawkFabMenuItem(
            label: 'New Chat',
            ontap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FilledButtons(
                          text: 'Search For User',
                          onPressed: () => Get.to(() => const SearchScreen()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.add),
            color: const Color(0xe50d004c),
            labelColor: Colors.white,
            labelBackgroundColor: const Color(0xe50d004c),
          ),
          HawkFabMenuItem(
            label: 'Join Public Chat',
            ontap: () {
              showToast('Comming Soon!');
            },
            icon: const Icon(Iconsax.people),
            color: const Color(0xe50d004c),
            labelColor: Colors.white,
            labelBackgroundColor: const Color(0xe50d004c),
          ),
          HawkFabMenuItem(
            label: 'Share',
            ontap: () {
              showToast('Comming Soon!');
            },
            icon: const Icon(Icons.share),
            color: const Color(0xe50d004c),
            labelColor: Colors.white,
            labelBackgroundColor: const Color(0xe50d004c),
          ),
        ],
        body: Column(
          children: [
            // SizedBox(height: 30.h),
            MyTabBar(controller: _tabController),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const ChatTab(),
                  const MomentsTab(),
                  CallTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyTabBar extends StatefulWidget implements PreferredSizeWidget {
  final TabController controller;
  const MyTabBar({
    super.key,
    required this.controller,
  });

  @override
  State<MyTabBar> createState() => _MyTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}

class _MyTabBarState extends State<MyTabBar> {
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      print("CHANGED");
      pageIndex = widget.controller.index;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.addListener(() {
      print("REVERSED");
      pageIndex = widget.controller.index;
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 28.h),
      color: AppColors.secondaryColor,
      child: Column(
        children: [
          // SizedBox(height: 10.h),
          TabBar(
            indicatorColor: AppColors.white,
            controller: widget.controller,
            tabs: [
              Tab(
                child: Text(
                  "Chats",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Moments",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "Calls",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if ([0, 1].contains(pageIndex)) ...[
            SizedBox(height: 5.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const AddStory();
                    }));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC4C4C4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 45,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 6.5.h),
                      Text(
                        "Update Moment",
                        style: TextStyle(
                          color: const Color(0xb2ffffff),
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10, right: 10.w),
                    height: 100,
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                    return const MomentsScreens();
                                  }));
                                },
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC4C4C4),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.orange),
                                    image: const DecorationImage(
                                      image: AssetImage("assets/mBg.jpg"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 6.5.h),
                            Text(
                              "Andrey",
                              style: TextStyle(
                                color: const Color(0xb2ffffff),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 7.h)
          ],
        ],
      ),
    );
  }
}
