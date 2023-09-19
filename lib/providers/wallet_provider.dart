import 'package:web3dart/web3dart.dart';
import 'package:flutter/foundation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xmtp/xmtp.dart';
import 'package:web3dart/credentials.dart';

// import 'dart:math';

// abstract class WalletAddressService {
//   String generateMnemonic();
//   Future<String> generatePrivateKey(String mnemonic);
//   Future<EthereumAddress> generatePublicKey(String privateKey);
// }

class WalletProvider extends ChangeNotifier {
  // Variable to store the private key
  String? privateKey;
  EthereumAddress? address;
  String? password;
  Client? client;

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  Future<String> initWalletState(String mnemonic) async {
    try {
      await generatePrivateKey(mnemonic);
      await generatePublicKey(privateKey!);
      return "Done";
    } catch (e) {
      return (e.toString());
    }
  }

  Future generatePrivateKey(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    privateKey = HEX.encode(master.key);
  }

  Future generatePublicKey(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    address = private.address;
  }

  // Future<void> setClient(privateKey) async {
  //   if (privateKey != null) {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey!);
  //     var api = xmtp.Api.create(host: 'production.xmtp.network');
  //     Client client =
  //         await xmtp.Client.createFromWallet(api, credentials.asSigner());

  //     Uint8List key = client.keys.writeToBuffer();

  //     Hive.box(appName).put('xmpt_key', key);
  //   }
  // }

  // Future<void> sendMessage(privateKey, address, message) async {
  //   // print(privateKey);
  //   if (privateKey != null) {
  //     await setClient(privateKey);
  //     var conversations = await client?.listConversations();
  //     print(conversations);
  //     var convo = await client?.newConversation(address);
  //     await client?.sendMessage(convo!, message);
  //   }
  // }
}
