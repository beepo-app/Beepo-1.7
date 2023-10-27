import 'package:beepo/widgets/toast.dart';
import 'package:flutter/foundation.dart';
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
    return client.streamMessages(convo!);
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
  Future<xmtp.Conversation> newConversation(String address, {Map<String, String>? metadata}) async {
    try {
      var convo = await client.newConversation(
        address,
        conversationId: _conversationId,
        metadata: metadata!,
      );
      notifyListeners();
      return convo;
    } catch (e) {
      showToast('User is not on XMTP network');
      dev.log(e.toString());
      rethrow;
    }
  }

  //check if can chat
  Future<bool> checkAddress(String address) async {
    try {
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
      print(e);
      rethrow;
    }
  }
}
