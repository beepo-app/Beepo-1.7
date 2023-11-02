import 'dart:async';
import 'dart:math';

import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/screens/messaging/chats/chat_dm_screen.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> items = ['Address', 'Usernames'];

  String? selectedItem = 'Usernames';

  bool isFound = false;

  Conversation? convo;
  Timer? searchOnStoppedTyping;

  final random_ = Random();

  final TextEditingController _textFieldController = TextEditingController();

  _onChangeHandler(value) {
    setState(() {
      isFound = false;
    });
    const duration = Duration(milliseconds: 800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    if (value.length == 42) {
      final xmtpProvider = Provider.of<XMTPProvider>(context, listen: false);

      if (selectedItem == 'Usernames') {
      } else {
        var res = await xmtpProvider.newConversation(value);

        setState(() {
          isFound = true;
          convo = res;
        });
      }
    } else {
      showToast('Address Length must be equal to 42');
    }
  }

  @override
  Widget build(BuildContext context) {
    final xmtpProvider = Provider.of<XMTPProvider>(context, listen: false);
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 110.h,
            width: double.infinity,
            color: AppColors.secondaryColor,
            child: Column(
              children: [
                // SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.only(top: 14.h, left: 10.w),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30, // Increase the size of the arrow
                          color: AppColors.white,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: PopupMenuButton<String>(
                            position: PopupMenuPosition.under,
                            initialValue: selectedItem,
                            onSelected: (String item) {
                              setState(() {
                                selectedItem = item;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return items.map((String item) {
                                return PopupMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      color: AppColors.black, // Change text color
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            offset: const Offset(90, -90),
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedItem!,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    top: 10.h,
                  ),
                  child: TextField(
                    style: const TextStyle(color: Color(0xff697077), fontSize: 15),
                    controller: _textFieldController,
                    onChanged: _onChangeHandler,
                    decoration: InputDecoration(
                      hintText: 'Start Typing ...',
                      hintStyle: const TextStyle(color: Color(0xff697077), fontSize: 15),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.white,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white, width: 0.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.white,
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: isFound ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  isFound
                      ? GestureDetector(
                          onTap: () async {
                            // var con = await xmtpProvider.newConversation(_textFieldController.text);
                            // Get.to(() => ChatDmScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration:
                                BoxDecoration(border: Border.all(color: AppColors.secondaryColor, width: 1), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.primaries[random_.nextInt(Colors.primaries.length)][random_.nextInt(9) * 100],
                                  child: Text(
                                    _textFieldController.text.substring(0, 2),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${_textFieldController.text.substring(0, 3)}...${_textFieldController.text.substring(_textFieldController.text.length - 7, _textFieldController.text.length)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/concept_of_Unknown_things.svg",
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 15),
                              const Text("No results found"),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
