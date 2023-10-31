import 'dart:math';

import 'package:beepo/constants/constants.dart';
import 'package:beepo/providers/account_provider.dart';
import 'package:beepo/providers/wallet_provider.dart';
import 'package:beepo/providers/xmtp.dart';
import 'package:beepo/screens/messaging/chats/chat_dm_screen.dart';
import 'package:beepo/widgets/commons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/web3dart.dart';
import 'package:xmtp/xmtp.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  List? conversation;

  @override
  void initState() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    final xmtpProvider = Provider.of<XMTPProvider>(context, listen: false);

    getMessages() async {
      await xmtpProvider.getClient('null');
      // print(xmtpProvider.client.address);
      // return;
      // var con = await xmtpProvider.listConversations();
      // conversation = xmtpProvider.conversations;
      // print(conversation);
      // print(await xmtpProvider.listMessages(convo: conversation![0]));
    }

    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final xmtpProvider = Provider.of<XMTPProvider>(context, listen: false);
    conversation = xmtpProvider.conversations;
    // print(conversation);

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
            child: Consumer<XMTPProvider>(
              builder: (BuildContext context, XMTPProvider provider, _) {
                if (provider.isLoadingConversations) {
                  return Center(
                    child: loadingDialog('Loading Messages!'),
                  );
                }

                final convos = provider.conversations;
                if (convos.isEmpty) {
                  return const Center(child: Text('No conversations yet'));
                }

                return FutureBuilder<List<DecodedMessage>>(
                  future: context.watch<XMTPProvider>().mostRecentMessage(convo: convos),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<DecodedMessage>? messages = snapshot.data;

                    // convos.sort((a, b) {
                    //   // Compare the message time of conversations 'a' and 'b'
                    //   DateTime? timeA = messages!.firstWhere((element) => element.topic == a.topic).sentAt;
                    //   DateTime? timeB = messages.firstWhere((element) => element.topic == b.topic).sentAt;

                    //   if (timeB != null) {
                    //     return timeB.compareTo(timeA); // Sort in descending order
                    //   } else if (timeA != null) {
                    //     return -1; // 'a' has a message, 'b' doesn't have
                    //   } else if (timeB != null) {
                    //     return 1; // 'b' has a message, 'a' doesn't have
                    //   } else {
                    //     return 0; // Both 'a' and 'b' don't have messages
                    //   }
                    // });

                    // print(messages![0].sentAt);
                    // return CircularProgressIndicator();

                    return ListView.builder(
                      itemCount: convos.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final convo = convos[index];

                        DecodedMessage? message = messages!.firstWhereOrNull((element) => element.topic == convo.topic);
                        print(message);
                        // return CircularProgressIndicator();
                        if (message != null) {
                          return ChatListItem(convo: convo, message: message);
                        }
                        return const SizedBox();
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    Key? key,
    required this.convo,
    required this.message,
  }) : super(key: key);

  final Conversation convo;
  final DecodedMessage message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: AccountProvider().getUserByAddress(EthereumAddress.fromHex(convo.peer.hexEip55)),
      builder: (ctx, user) {
        if (!user.hasData && !user.hasError) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ListTile(
              leading: const CircleAvatar(),
              title: Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          );
        }

        bool noBeepoAcct = user.data!['error'] == 'User Not Found';
        String senderAddress = convo.peer.hexEip55;

        final random_ = Random();

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: noBeepoAcct
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
          title: Text(
            noBeepoAcct ? '${senderAddress.substring(0, 3)}...${senderAddress.substring(senderAddress.length - 7, senderAddress.length)}' : 'Ajem',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: message == null
              ? SizedBox()
              : Row(
                  children: [
                    Expanded(
                        child: Text(
                      message.content.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("jm").format(message.sentAt),
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
                () => ChatDmScreen(conversation: convo, user: user),
              );
            } else {
              Get.to(
                () => ChatDmScreen(
                  conversation: convo,
                ),
              );
            }
          },
        );
      },
    );
  }
}
