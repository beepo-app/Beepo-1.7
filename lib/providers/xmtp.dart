import 'dart:convert';

import 'package:beepo/widgets/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:web3dart/credentials.dart';
import 'dart:developer' as dev;

class XMTPProvider extends ChangeNotifier {
  XMTPProvider() {
    getClient('null');
  }

  final String _conversationId = 'chat';
  String? ethPrivateKey;
  final Box _box = Hive.box('beepo2.0');

  late xmtp.Client client;
  List<xmtp.Conversation> _conversations = [];
  bool _isLoadingConversations = false;

  // Getter for conversations
  List<xmtp.Conversation> get conversations => _conversations;

  // Getter for isLoadingConversations
  bool get isLoadingConversations => _isLoadingConversations;

  //get client and notify listeners
  Future<xmtp.Client> getClient(String? privateKey) async {
    var key = _box.get('xmpt_key');
    bool isSignedUp = _box.get('isSignedUp', defaultValue: false);
    print(isSignedUp);

    if (isSignedUp) {
      if (key != null) {
        client = await initClientFromKey();
        notifyListeners();
      } else {
        client = await initClient(privateKey!);
        notifyListeners();
      }
    }
    await listConversations();
    return client;
  }

  Future<xmtp.Client> initClient(String privateKey) async {
    try {
      EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);

      print(credentials);
      var api = xmtp.Api.create(host: 'production.xmtp.network');
      var client = await xmtp.Client.createFromWallet(api, credentials.asSigner());

      Uint8List key = client.keys.writeToBuffer();

      Hive.box('beepo2.0').put('xmpt_key', key);
      // notifyListeners();
      return client;
    } catch (e) {
      if (kDebugMode) {
        print({"error xmtp 61": e});
      }
      rethrow;
    }
  }

  Future<xmtp.Client> initClientFromKey() async {
    Uint8List key = Hive.box('beepo2.0').get('xmpt_key');

    print('object');
    var privateKey = xmtp.PrivateKeyBundle.fromBuffer(key);

    var api = xmtp.Api.create(host: 'production.xmtp.network');
    client = await xmtp.Client.createFromKeys(api, privateKey);
    // await listConversations();
    return client;
  }

  //list conversations stream
  Stream<xmtp.DecodedMessage> streamMessages({xmtp.Conversation? convo}) {
    var mes = client.streamMessages(convo!);
    return mes;
  }

  //send message
  void sendMessage({xmtp.Conversation? convo, String? content}) async {
    try {
      await client.sendMessage(convo!, content!);

      print('msg sent');
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchConversations() async {
    _isLoadingConversations = true;
    notifyListeners();
    _conversations = await listConversations();
    _isLoadingConversations = false;
    notifyListeners();
  }

  //list conversations
  Future<List<xmtp.Conversation>> listConversations() async {
    try {
      // client = await getClient(privateKey);
      _conversations = await client.listConversations();
      notifyListeners();
      // print(convos);
      return _conversations;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //list messages
  Future<List<xmtp.DecodedMessage>> listMessages({xmtp.Conversation? convo}) async {
    try {
      var msgs = await client.listMessages(convo!);
      return msgs;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //create new conversation
  Future<xmtp.Conversation> newConversation(String address) async {
    try {
      var convo = await client.newConversation(
        address.trim(),
        conversationId: _conversationId,
      );
      notifyListeners();
      return convo;
    } catch (e) {
      dev.log(e.toString());
      if (e.toString().contains('Invalid argument (address)')) {
        showToast('Invalid Address Entered');
      } else if (e.toString().contains('is not on the XMTP network')) {
        showToast('Address is not on XMTP network');
      } else if (e.toString().contains('Address has invalid case-characters')) {
        showToast('Address has invalid case-characters');
      }
      rethrow;
    }
  }

  //check if can chat
  Future<bool> checkAddress(String address) async {
    try {
      print(client.address);
      return await client.canMessage(address);
    } catch (e) {
      return false;
    }
  }

  Future<List<xmtp.DecodedMessage>> mostRecentMessage({List<xmtp.Conversation>? convo}) async {
    try {
      var msg = await client.listBatchMessages(convo!, limit: 1);

      return msg;
    } catch (e) {
      print('${e.toString()} xmtp 168');
      rethrow;
    }
  }

  Future<void> saveListMessagesToStorage(xmtp.Conversation convo) async {
    try {
      var msg = await client.listMessages(convo, limit: 1);

      msg.map(
        (e) => {},
      );
      var msgJson = {
        "content": msg[0].content,
        "sentAt": msg[0].sentAt,
        "id": msg[0].id,
        "sender": msg[0].sender,
        "topic": msg[0].topic,
        "re": msg[0].contentType
      };
// "topic":msg[0].,

      print(jsonDecode(msgJson.toString()));
    } catch (e) {
      print('${e.toString()} xmtp 180');
      rethrow;
    }
  }
}
