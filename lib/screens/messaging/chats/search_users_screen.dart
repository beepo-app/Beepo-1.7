import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/screens/messaging/chats/chat_dm_screen.dart';
import 'package:beepo/session/foreground_session.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:string_to_color/string_to_color.dart';
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
  bool searching = false;

  Conversation? convo;
  String? topic;
  String? address;
  String? username;
  Timer? searchOnStoppedTyping;
  Map? userData;

  final random_ = Random();

  final TextEditingController _textFieldController = TextEditingController();

  _onChangeHandler(value) {
    setState(() {
      isFound = false;
    });
    const duration = Duration(milliseconds: 1200); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () => search(value)));
  }

  search(value) async {
    if (selectedItem == 'Usernames') {
      if (value.length > 1) {
        var users = await Hive.box('beepo2.0').get('allUsers');

        print(users.toList());

        // final accountProvider = Provider.of<AccountProvider>(context, listen: false);
        // var data = await accountProvider.getUserByUsernme(value);
        // if (data['status'] == 'success') {
        //   setState(() {
        //     searching = false;
        //     isFound = true;
        //     address = data['data'][0]['ethAddress'].toString();
        //     userData = data;
        //     username = data['data'][0]['username'];
        //   });
        //   return;
        // }
      }
    } else {
      if (value.length == 42) {
        setState(() {
          searching = true;
        });
        Map res = await session.newConversation(value);
        print(res);
        if (res['success']) {
          setState(() {
            searching = false;
            isFound = true;
            topic = res['data']['topic'];
            address = res['data']['address'];
          });
        }
        // var res = await xmtpProvider.newConversation(value);
        return;
      }
      showToast('Address Length must be equal to 42');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  searching
                      ? const CircularProgressIndicator()
                      : isFound
                          ? userData!.length > 1
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: userData!.length,
                                  itemBuilder: (context, index) {
                                    Future<Map> newConvo() async => await session.newConversation(userData!['data'][index]['ethAddress']);

                                    return GestureDetector(
                                      onTap: () async {
                                        Map data = await newConvo();
                                        if (data['error'] == null) {
                                          var topic = data['data']['topic'];
                                          var address = data['data']['address'];

                                          Get.to(
                                            () => ChatDmScreen(
                                              topic: topic!,
                                              senderAddress: address,
                                            ),
                                          );
                                          return;
                                        } else {
                                          showToast(data['error']);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(100),
                                              child: Image.memory(
                                                base64Decode(userData!['data'][index]['image']),
                                                height: 45,
                                                width: 45,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              userData!['data'][index]['username'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : GestureDetector(
                                  onTap: () async {
                                    Get.to(() => ChatDmScreen(
                                          topic: topic!,
                                          senderAddress: address,
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        selectedItem == 'Usernames'
                                            ? ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Image.memory(
                                                  base64Decode(userData!['data'][0]['image']),
                                                  height: 45,
                                                  width: 45,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : CircleAvatar(
                                                backgroundColor: ColorUtils.stringToColor(address!),
                                                child: Text(
                                                  _textFieldController.text.substring(0, 2),
                                                  style: const TextStyle(color: Colors.white),
                                                ),
                                              ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        selectedItem == 'Usernames'
                                            ? Text(
                                                username!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                              )
                                            : Text(
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
