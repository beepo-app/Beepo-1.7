//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:iconsax/iconsax.dart';
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
            // Background Image

            Positioned(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List<Widget>.generate(
                        _pages.length,
                        (index) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                            ))))),

            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 100,
                child: Container(
                  color: Colors.black54,
                  child: Text(_activePage.toString()),
                )),

            // Icons on the Background
            Positioned(
              top: 450,
              left: 293,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/white-heart.svg',
                    width: 50,
                    height: 50,
                    // ignore: deprecated_member_use
                    color: const Color.fromARGB(255, 248, 245, 245),
                  ),
                  const Text(
                    '112.10q',
                    style: TextStyle(
                      color: Color.fromARGB(255, 251, 250, 252),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 520,
              left: 300,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/share.svg',
                    width: 30,
                    height: 30,
                    // ignore: deprecated_member_use
                    color: const Color.fromARGB(255, 248, 245, 245),
                  ),
                  const Text(
                    '123',
                    style: TextStyle(
                      color: Color.fromARGB(255, 253, 252, 253),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),

            // Add more icons as needed
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
        decoration: BoxDecoration(
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
