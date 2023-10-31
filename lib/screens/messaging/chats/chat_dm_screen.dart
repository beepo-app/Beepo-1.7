import 'dart:math';

import 'package:beepo/components/bottom_nav.dart';
import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/screens/messaging/chat_tabs_screen.dart';
import 'package:beepo/screens/messaging/chats/chat_tab.dart';
import 'package:beepo/screens/profile/user_profile_screen.dart';
import 'package:beepo/widgets/commons.dart';
import 'package:beepo/widgets/filled_buttons.dart';
import 'package:beepo/widgets/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

class ChatDmScreen extends StatefulWidget {
  final Conversation? conversation;
  final AsyncSnapshot<Map<dynamic, dynamic>>? user;
  const ChatDmScreen({super.key, this.user, this.conversation});

  @override
  State<ChatDmScreen> createState() => _ChatDmScreenState();
}

class _ChatDmScreenState extends State<ChatDmScreen> {
  List<DecodedMessage> messages = [];
  Future<List<DecodedMessage>>? getMessages;
  // UserModel user;
  // Future<UserModel> getUserDetails;

  @override
  void initState() {
    super.initState();

    getMessages = context.read<XMTPProvider>().listMessages(convo: widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    Map user = widget.user != null ? widget.user!.data! : {'error': "User Not Found"};
    Conversation convo = widget.conversation!;

    bool noBeepoAcct = user['error'] == 'User Not Found';
    String senderAddress = convo.peer.hexEip55;

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
                            convo.peer.hexEip55.substring(0, 2),
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
      body: FutureBuilder<List<DecodedMessage>>(
        future: getMessages,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          messages = snapshot.data!;

          return StreamBuilder<DecodedMessage>(
            stream: context.read<XMTPProvider>().streamMessages(convo: widget.conversation),
            builder: (context, snapshot) {
              print(snapshot);
              if (snapshot.hasData) {
                messages.insert(0, snapshot.data!);
              }
              return Column(
                children: [
                  Expanded(
                    child: GroupedListView(
                      elements: messages.reversed.toList(),
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
                        bool isMe = msg.sender != widget.conversation!.peer;

                        // print(msg.content.toString().isJSON);

                        // bool isTransfer = msg.content.toString().isJSON;

                        // if (isTransfer) {
                        //   final transfer = jsonDecode(msg.content.toString());

                        //   return TransferPreview(
                        //     transfer: transfer,
                        //     isMe: isMe,
                        //   );
                        // }

                        return ChatMessageWidget(
                          message: msg,
                          isMe: isMe,
                        );
                      },
                      separator: const SizedBox(height: 10),
                      order: GroupedListOrder.DESC,
                    ),
                  ),
                  ChatControlsWidget(
                    convo: widget.conversation!,
                    // user: user,
                  ),
                  // Container(
                  //   height: 42.h,
                  //   // color: Colors.grey.shade100,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(bottom: 7.h, right: 6.w, left: 6.w),
                  //     child: Row(
                  //       children: [
                  //         IconButton(
                  //           onPressed: () {
                  //             print('send');
                  //           },
                  //           icon: Icon(
                  //             Icons.send,
                  //             size: 30.sp,
                  //             color: AppColors.secondaryColor,
                  //           ),
                  //         ),
                  //         Expanded(
                  //           child: TextField(
                  //             keyboardType: TextInputType.multiline,
                  //             minLines: 1,
                  //             maxLines: 5,
                  //             style: TextStyle(
                  //               fontSize: 14.sp,
                  //               color: AppColors.textGrey,
                  //             ),
                  //             decoration: InputDecoration(
                  //               contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  //               filled: true,
                  //               fillColor: AppColors.white,
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(15.r),
                  //                 borderSide: BorderSide.none,
                  //               ),
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(15.r),
                  //                 borderSide: BorderSide.none,
                  //               ),
                  //               hintText: "Message",
                  //               hintStyle: TextStyle(
                  //                 fontSize: 14.sp,
                  //                 color: AppColors.dividerGrey,
                  //               ),
                  //               suffixIcon: IconButton(
                  //                 onPressed: () {
                  //                   print('send');
                  //                 },
                  //                 icon: Icon(
                  //                   Iconsax.dollar_circle,
                  //                   size: 23.sp,
                  //                   color: AppColors.secondaryColor,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(width: 8.w),
                  //         IconButton(
                  //           onPressed: () {
                  //             print('send');
                  //           },
                  //           icon: Icon(
                  //             Icons.send,
                  //             size: 30.sp,
                  //             color: AppColors.secondaryColor,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final DecodedMessage? message;
  final bool isMe;

  const ChatMessageWidget({Key? key, this.message, required this.isMe}) : super(key: key);

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

class ChatControlsWidget extends StatefulWidget {
  const ChatControlsWidget({
    Key? key,
    this.convo,
    // this.user,
  }) : super(key: key);

  final Conversation? convo;
  // final ? user;

  @override
  State<ChatControlsWidget> createState() => _ChatControlsWidgetState();
}

class _ChatControlsWidgetState extends State<ChatControlsWidget> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {});
    });
  }

  // void sendToken(Wallet wallet) {
  //   final amount = TextEditingController();
  //   Get.dialog(
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(15),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               "Send ${wallet.ticker}",
  //               style: const TextStyle(
  //                 fontSize: 18,
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             TextField(
  //               controller: amount,
  //               keyboardType: TextInputType.number,
  //               style: const TextStyle(
  //                 color: Color(0xff0d004c),
  //                 fontSize: 18,
  //               ),
  //               decoration: InputDecoration(
  //                 isDense: true,
  //                 hintText: "Amount",
  //                 suffixText: wallet.ticker,
  //                 border: const OutlineInputBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(15)),
  //                     borderSide: BorderSide(
  //                       color: Colors.grey,
  //                       width: 1,
  //                     )),
  //                 focusedBorder: const OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(15)),
  //                   borderSide: BorderSide(width: 1, color: Colors.grey),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             FilledButtons(
  //               color: secondaryColor,
  //               text: "Continue",
  //               onPressed: () {
  //                 if (amount.text.isEmpty) {
  //                   showToast('Please enter amount');
  //                 } else {
  //                   Get.back();
  //                   Get.off(
  //                     ConfirmTransfer(
  //                       wallet: wallet,
  //                       amount: double.parse(amount.text),
  //                       address: wallet.ticker == "BITCOIN" ? widget.user!.bitcoinWalletAddress : widget.user!.hdWalletAddress,
  //                       convo: widget.convo,
  //                     ),
  //                   );
  //                 }
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    style: const TextStyle(fontSize: 16),
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: const TextStyle(color: Color(0xff697077), fontSize: 15),
                      prefixIcon: messageController.text.isEmpty
                          ? IconButton(
                              onPressed: () {
                                // context
                                //     .read<ChatNotifier>()
                                //     .cameraUploadImageChat(widget.model.uid);
                              },
                              icon: SvgPicture.asset('assets/camera.svg'),
                            )
                          : null,
                      suffixIcon: messageController.text.isEmpty
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
              if (messageController.text.isEmpty) {
                showToast('Please Enter A Message!');
                return;
              }
              context.read<XMTPProvider>().sendMessage(
                    convo: widget.convo,
                    content: messageController.text,
                  );
              messageController.clear();

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
    );
  }
}



//  Container(
//       height: 50.h,
//       color: Colors.grey.shade100,
//       child: Padding(
//         padding: EdgeInsets.only(bottom: 7.h, right: 6.w),
//         child: Row(
//           children: [
//             Expanded(
//               child: TextField(
//                 keyboardType: TextInputType.multiline,
//                 minLines: 1,
//                 maxLines: 5,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: AppColors.textGrey,
//                 ),
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
//                   filled: true,
//                   fillColor: AppColors.white,
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.r),
//                     borderSide: BorderSide.none,
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.r),
//                     borderSide: BorderSide.none,
//                   ),
//                   hintText: "Message",
//                   hintStyle: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColors.dividerGrey,
//                   ),
//                   prefixIcon: SizedBox(
//                     width: 30,
//                     child: IconButton(
//                       onPressed: () {
//                         // context
//                         //     .read<ChatNotifier>()
//                         //     .cameraUploadImageChat(widget.model.uid);
//                       },
//                       constraints: BoxConstraints(
//                         maxWidth: 30.sp,
//                       ),
//                       // style: const ButtonStyle(iconSize: MaterialStatePropertyAll(23)),
//                       icon: SvgPicture.asset('assets/camera.svg'),
//                     ),
//                   ),
//                   suffixIcon: IconButton(
//                     onPressed: () {},
//                     icon: Icon(
//                       Iconsax.dollar_circle,
//                       size: 23.sp,
//                       color: AppColors.secondaryColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 8.w),
//             IconButton(
//               onPressed: () {},
//               icon: Icon(
//                 Icons.send,
//                 size: 30.sp,
//                 color: AppColors.secondaryColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );