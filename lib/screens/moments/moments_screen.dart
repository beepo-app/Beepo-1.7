import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/messaging/chats/chat_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MomentsScreens extends StatefulWidget {
  const MomentsScreens({super.key});
  @override
  State<MomentsScreens> createState() => _MomentsScreensState();
}

class _MomentsScreensState extends State<MomentsScreens> {
  final PageController _pageController = PageController(initialPage: 0);
  int _activePage = 0;

  final List<Widget> _pages = [
    const PageOne(),
    const PageTwo(),
    const PageThree()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _activePage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index % _pages.length];
              },
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.generate(
                  _pages.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Container(
                          width: 100.0, // Adjust the width as needed
                          height: 5.0, // Adjust the height as needed
                          decoration: BoxDecoration(
                            color: _activePage == index
                                ? Colors.white
                                : Colors.grey, // Background color
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius to round the corners
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 17.w,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const ChatTab();
                      }));
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundImage: const AssetImage("assets/mBg.jpg"),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        children: [
                          Text(
                            "Angel Okwonkwo",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.white,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.visibility,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "13.1K Views",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 65.h,
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: const Text(
                  "had fun today atthe global Beepo App blockchain innovation Conference",
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Icons on the Background
            Positioned(
              top: 340.h,
              left: 250.w,
              right: 0,
              child: Column(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.favorite,
                      size: 50,
                      color: AppColors.white,
                    ),
                  ),
                  const Text(
                    '112.10q',
                    style: TextStyle(
                      color: Color.fromARGB(255, 251, 250, 252),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/share.svg',
                      width: 30.w,
                      height: 30.h,
                      // ignore: deprecated_member_use
                      color: const Color.fromARGB(255, 248, 245, 245),
                    ),
                  ),
                  const Text(
                    '676',
                    style: TextStyle(
                      color: Color.fromARGB(255, 253, 252, 253),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mBg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  const PageThree({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
      ),
    );
  }
}
