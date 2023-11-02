import 'dart:math';

import 'package:beepo/components/address_avatar.dart';
import 'package:beepo/components/address_chip.dart';
import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/screens/messaging/chats/chat_dm_screen.dart';
import 'package:beepo/session/foreground_session.dart';
import 'package:beepo/utils/hooks.dart';
import 'package:beepo/widgets/commons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xmtp/xmtp.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List? conversation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var me = useMe();
    // var conversations = useConversationList();
    // var refresher = useConversationsRefresher();

    // debugPrint('conversations ${conversations.data?.length ?? 0}');

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Messages",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.search,
                        color: AppColors.secondaryColor,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.more_vert_outlined,
                      color: AppColors.secondaryColor,
                      size: 18.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Chat(),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
          //   child: Consumer<XMTPProvider>(
          //     builder: (BuildContext context, XMTPProvider provider, _) {
          //       if (provider.isLoadingConversations) {
          //         return Center(
          //           child: loadingDialog('Loading Messages!'),
          //         );
          //       }

          //       final convos = provider.conversations;
          //       // XMTPProvider().mostRecentMessage(convos: convos);
          //       print(convos);
          //       if (convos.isEmpty) {
          //         return const Center(child: Text('No conversations yet'));
          //       }

          //       // print(convos);
          //       // return CircularProgressIndicator();

          //       return FutureBuilder<List<DecodedMessage>>(
          //         future: context.watch<XMTPProvider>().mostRecentMessage(convos: convos),
          //         builder: (context, snapshot) {
          //           if (!snapshot.hasData) {
          //             return const Center(
          //               child: CircularProgressIndicator(),
          //             );
          //           }

          //           List<DecodedMessage>? messages = snapshot.data;

          //           // convos.sort((a, b) {
          //           //   // Compare the message time of conversations 'a' and 'b'
          //           //   DateTime? timeA = messages!.firstWhere((element) => element.topic == a.topic).sentAt;
          //           //   DateTime? timeB = messages.firstWhere((element) => element.topic == b.topic).sentAt;

          //           //   if (timeB != null) {
          //           //     return timeB.compareTo(timeA); // Sort in descending order
          //           //   } else if (timeA != null) {
          //           //     return -1; // 'a' has a message, 'b' doesn't have
          //           //   } else if (timeB != null) {
          //           //     return 1; // 'b' has a message, 'a' doesn't have
          //           //   } else {
          //           //     return 0; // Both 'a' and 'b' don't have messages
          //           //   }
          //           // });

          //           // print(messages![0].sentAt);
          //           // return CircularProgressIndicator();

          //           return ListView.builder(
          //             itemCount: convos.length,
          //             shrinkWrap: true,
          //             padding: EdgeInsets.zero,
          //             physics: const NeverScrollableScrollPhysics(),
          //             itemBuilder: (context, index) {
          //               final convo = convos[index];

          //               DecodedMessage? message = messages!.firstWhereOrNull((element) => element.topic == convo.topic);
          //               print(message);
          //               return CircularProgressIndicator();
          //               if (message != null) {
          //                 return ChatListItem(convo: convo, message: message);
          //               }
          //               return const SizedBox();
          //             },
          //           );
          //         },
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String topic;

  ChatListItem({Key? key, required this.topic}) : super(key: Key(topic));

  @override
  Widget build(BuildContext context) {
    var me = useMe();
    var conversation = useConversation(topic);
    var lastMessage = useLastMessage(topic);
    var unreadCount = useNewMessageCount(topic).data ?? 0;
    var content = (lastMessage.data?.content ?? "") as String;
    var meSentLast = (lastMessage.data?.sender == me);
    var senderAddress = conversation.data?.peer.toString();
    var lastSentAt = lastMessage.data?.sentAt ?? DateTime.now();

    bool noBeepoAcct = true;
    final random_ = Random();

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: noBeepoAcct
          ? CircleAvatar(
              backgroundColor: Colors.primaries[random_.nextInt(Colors.primaries.length)][random_.nextInt(9) * 100],
              child: Text(
                senderAddress!.substring(0, 2),
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
      title: Text(
        noBeepoAcct ? '${senderAddress.substring(0, 3)}...${senderAddress.substring(senderAddress.length - 7, senderAddress.length)}' : 'Ajem',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: content == null
          ? SizedBox()
          : Row(
              children: [
                Expanded(
                    child: Text(
                  content.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(width: 8),
                Text(
                  DateFormat("jm").format(lastSentAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
      onTap: () {
        if (noBeepoAcct) {
          // Get.to(
          //   () => ChatDmScreen(conversation: conversation),
          // );
        } else {
          // Get.to(
          //   () => ChatDmScreen(
          //     conversation: convo,
          //   ),
          // );
        }
      },
    );

    // return ListView.builder(
    //   itemCount: messages.length,
    //   itemBuilder: (ctx, index) {
    //     bool noBeepoAcct = messages[index]['beepoAcct']['error'] == 'User Not Found';
    //     String senderAddress = messages[index]['sender'];

    //     print(messages[index]);

    //     final random_ = Random();

    //   },
    // );
  }
}

class Chat extends HookWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conversations = useConversationList();

    var refresher = useConversationsRefresher();
    debugPrint('conversations ${conversations.data?.length ?? 0}');

    return RefreshIndicator(
      onRefresh: refresher,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return conversations.hasData ? ConversationListItem(topic: conversations.data![index].topic) : Container();
        },
        itemCount: conversations.hasData ? conversations.data!.length : 0,
      ),
    );
  }
}

class ConversationListItem extends HookWidget {
  final String topic;

  ConversationListItem({Key? key, required this.topic}) : super(key: Key(topic));

  @override
  Widget build(BuildContext context) {
    var me = useMe();
    var conversation = useConversation(topic);
    var lastMessage = useLastMessage(topic);
    var unreadCount = useNewMessageCount(topic).data ?? 0;
    var content = (lastMessage.data?.content ?? "") as String;
    var meSentLast = (lastMessage.data?.sender == me);
    var lastSentAt = lastMessage.data?.sentAt ?? DateTime.now();
    var senderAddress = conversation.data?.peer.toString();

    bool noBeepoAcct = true;
    final random_ = Random();

    print(unreadCount);
    print(conversation);

    // return CircularProgressIndicator();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: noBeepoAcct
          ? CircleAvatar(
              backgroundColor: Colors.primaries[random_.nextInt(Colors.primaries.length)][random_.nextInt(9) * 100],
              child: Text(
                senderAddress?.substring(0, 2) ?? '',
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
      title: Text(
        noBeepoAcct ? '${senderAddress?.substring(0, 3)}...${senderAddress?.substring(senderAddress.length - 7, senderAddress.length)}' : 'Ajem',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: content == null
          ? SizedBox()
          : Row(
              children: [
                Expanded(
                    child: Text(
                  content.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(width: 8),
                Text(
                  DateFormat("jm").format(lastSentAt),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
      onTap: () {
        if (noBeepoAcct) {
          Get.to(
            () => ChatDmScreen(topic: topic),
          );
        } else {
          Get.to(
            () => ChatDmScreen(topic: topic),
          );
        }
      },
    );
  }
}
