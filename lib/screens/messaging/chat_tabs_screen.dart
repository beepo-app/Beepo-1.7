import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/messaging/calls/calls_tab.dart';
import 'package:beepo/screens/messaging/chats/chat_tab.dart';
import 'package:beepo/screens/moments/moments_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../moments/add_story.dart';
import '../moments/moments_screen.dart';

class ChatTabsScreen extends StatefulWidget {
  const ChatTabsScreen({super.key});

  @override
  State<ChatTabsScreen> createState() => _ChatTabsScreenState();
}

class _ChatTabsScreenState extends State<ChatTabsScreen>
    with TickerProviderStateMixin {
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
      // appBar: AppBar(
      //   bottom:
      // ),
      // NestedScrollView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   headerSliverBuilder: (context, innerBoxIsScrolled) {
      //     return [
      //       SliverAppBar(
      //         bottom: MyTabBar(
      //           controller: _tabController,
      //         ),
      //       ),
      //       // SliverToBoxAdapter(
      //       //   child: MyTabBar(
      //       //     controller: _tabController,
      //       //   ),
      //       // ),
      //     ];
      //   },
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
      padding: EdgeInsets.only(top: 20.h),
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
              children: [
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const AddStory();
                    }));
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: const BoxDecoration(
                          color: Color(0xFFC4C4C4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 35,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.9.h),
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
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const MomentsScreens();
                                  }));
                                },
                                child: Container(
                                  height: 70,
                                  width: 70,
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
