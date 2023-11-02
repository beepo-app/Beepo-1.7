import 'dart:math';

import 'package:beepo/components/bottom_nav.dart';
import 'package:beepo/constants/constants.dart';
import 'package:beepo/screens/profile/user_profile_screen.dart';
import 'package:beepo/utils/hooks.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:xmtp/xmtp.dart';

class ChatDmScreen extends HookWidget {
  final String topic;

  ChatDmScreen({Key? key, required this.topic}) : super(key: Key(topic));

  @override
  Widget build(BuildContext context) {
    var sender = useSendMessage();
    var sending = useState(false);
    var messages = useMessages(topic);
    var refresher = useMessagesRefresher(topic);
    var me = useMe();
    var input = useTextEditingController();
    var canSend = useState(false);
    useMarkAsOpened(topic);

    input.addListener(() => canSend.value = input.text.isNotEmpty);
    submitHandler() async {
      print(sending.value);
      print('sending.value');
      sending.value = true;
      await sender(topic, input.text).then((_) => input.clear()).whenComplete(() => sending.value = false);
    }

    bool noBeepoAcct = true;
    String senderAddress = messages.data![0].sender.toString();

    final random_ = Random();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.secondaryColor,
        toolbarHeight: 40.h,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const BottomNavHome();
                }));
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 25.sp,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UserProfileScreen();
                }));
              },
              child: Row(
                children: [
                  noBeepoAcct
                      ? CircleAvatar(
                          backgroundColor: Colors.primaries[random_.nextInt(Colors.primaries.length)][random_.nextInt(9) * 100],
                          child: Text(
                            senderAddress.substring(0, 2),
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: CachedNetworkImage(
                              imageUrl: 'https://res.cloudinary.com/dwruvre6o/image/upload/v1697100571/usdt_jiebah.png',
                              height: 40,
                              width: 40,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.secondaryColor,
                              )),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 10.w),
                  noBeepoAcct
                      ? Text(
                          '${senderAddress.substring(0, 3)}...${senderAddress.substring(senderAddress.length - 7, senderAddress.length)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: AppColors.white, fontWeight: FontWeight.w500),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sylvia Chirah",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              "@sylvia",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 8.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_outlined,
              color: AppColors.white,
              size: 18.sp,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GroupedListView(
                elements: messages.data!.reversed.toList(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                groupBy: (DecodedMessage element) {
                  return DateFormat('yMMMMd').format(element.sentAt);
                },
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                groupSeparatorBuilder: (String groupByValue) {
                  return SizedBox(
                    height: 40,
                    child: Align(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: AppColors.secondaryColor,
                        ),
                        child: Text(
                          groupByValue,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                floatingHeader: true,
                reverse: true,
                useStickyGroupSeparators: true,
                itemBuilder: (context, DecodedMessage msg) {
                  bool isMe = msg.sender == me;

                  // print(msg.content.toString().isJSON);

                  // bool isTransfer = msg.content.toString().isJSON;

                  // if (isTransfer) {
                  //   final transfer = jsonDecode(msg.content.toString());

                  //   return TransferPreview(
                  //     transfer: transfer,
                  //     isMe: isMe,
                  //   );
                  // }

                  // print(msg);
                  // return CircularProgressIndicator();

                  return ChatMessageWidget(
                    message: msg,
                    isMe: isMe,
                  );
                },
                separator: const SizedBox(height: 10),
                order: GroupedListOrder.DESC,
              ),
            ),
            Container(
              // height: 45.h,
              // color: Colors.transparent,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              // width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                          ),
                          child: TextField(
                            onSubmitted: (value) => canSend.value ? submitHandler : null,
                            style: const TextStyle(fontSize: 16),
                            controller: input,
                            decoration: InputDecoration(
                              hintText: 'Message',
                              hintStyle: const TextStyle(color: Color(0xff697077), fontSize: 15),
                              prefixIcon: input.text.isEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        // context
                                        //     .read<ChatNotifier>()
                                        //     .cameraUploadImageChat(widget.model.uid);
                                      },
                                      icon: SvgPicture.asset('assets/camera.svg'),
                                    )
                                  : null,
                              suffixIcon: input.text.isEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        // context
                                        //     .read<ChatNotifier>()
                                        //     .cameraUploadImageChat(widget.model.uid);
                                      },
                                      icon: SvgPicture.asset('assets/dollar.svg'),
                                    )
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            // expands: true,

                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // messageController.text.isEmpty
                  //     ? IconButton(
                  //         onPressed: () {
                  //           // showModalBottomSheet(
                  //           //     shape: const OutlineInputBorder(
                  //           //         borderSide: BorderSide.none,
                  //           //         borderRadius: BorderRadius.only(
                  //           //             topLeft: Radius.circular(20),
                  //           //             topRight: Radius.circular(20))),
                  //           //     context: context,
                  //           //     builder: (ctx) => CustomVoiceRecorderWidget(
                  //           //           isGroupChat: false,
                  //           //           receiverId: widget.model.uid,
                  //           //         ));
                  //         },
                  //         icon: SvgPicture.asset(
                  //           'assets/microphone.svg',
                  //           width: 27,
                  //           height: 27,
                  //         ))
                  //     :
                  IconButton(
                    onPressed: () async {
                      canSend.value && !sending.value ? submitHandler() : null;
                      // // var status = await OneSignal.shared.getDeviceState();
                      // //
                      // // var playerId = status.userId;
                      // await OneSignal.shared
                      //     .postNotification(OSCreateNotification(
                      //   playerIds: [player],
                      //   content: context.read<ChatNotifier>().chatText,
                      //   heading: 'Beepo',
                      //   subtitle: userM['displayName'],
                      //   sendAfter: DateTime.now(),
                      //   buttons: [
                      //     OSActionButton(text: "test1", id: "id1"),
                      //     OSActionButton(text: "test2", id: "id2"),
                      //   ],
                      //   androidSound:
                      //       'assets/mixkit-interface-hint-notification-911.wav',
                      //   androidSmallIcon: 'assets/beepo_img.png',
                      //
                      // )
                      // );
                      // context.read<ChatNotifier>().clearText();

                      // setState(() {
                      //   isReplying = false;
                      //   replyMessage = '';
                      // });
                      // EncryptData.encryptFernet(context.read<ChatNotifier>().chatText);
                      // OneSignal.shared.
                    },
                    icon: SvgPicture.asset('assets/send.svg'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final DecodedMessage? message;
  final bool isMe;

  const ChatMessageWidget({super.key, this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: !isMe ? const Color(0xFFC4C4C4) : const Color(0xff0E014C),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message!.content.toString(),
              style: TextStyle(
                color: !isMe ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat("jm").format(message!.sentAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: !isMe ? Colors.black : Colors.white,
                  ),
                ),
                if (isMe)
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
