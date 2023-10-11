import 'dart:convert';

import 'package:beepo/networks/erc20.dart';
import 'package:beepo/networks/networks.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/foundation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:get/get.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart' as wallet;
import 'package:http/http.dart' as http;

class WalletProvider extends ChangeNotifier {
  // Variable to store the private key
  String? ethPrivateKey;
  EthereumAddress? ethAddress;
  String? btcAddress;
  String? password;
  String? mnemonic;
  List? assets;
  String? totalBalance;

  String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  Future<String> initWalletState(String mnemonic_) async {
    try {
      mnemonic = mnemonic_;
      await generateBTCWallet(mnemonic_);
      await generateETHWallet(mnemonic_);
      await getAssets();
      return "Done";
    } catch (e) {
      return (e.toString());
    }
  }

  Future generateBTCWallet(mnemonic_) async {
    try {
      final privateKey = await getBTCPrivateKey(mnemonic_);
      final publicKey = wallet.bitcoin.createPublicKey(privateKey);
      final address = wallet.bitcoin.createAddress(publicKey);
      btcAddress = address;
    } catch (e) {
      print(e);
    }
  }

  Future getBTCPrivateKey(mnemonic_) async {
    try {
      final seed = wallet.mnemonicToSeed(mnemonic_.split(' '), passphrase: '0000');
      final master = wallet.ExtendedPrivateKey.master(seed, wallet.xprv);

      final root = master.forPath("m/44'/60'/0'/0");
      final privateKey = wallet.PrivateKey((root as wallet.ExtendedPrivateKey).key);
      return privateKey;
    } catch (e) {
      print(e);
    }
  }

  Future generateETHWallet(String mnemonic) async {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    String privateKey = HEX.encode(master.key);
    final address = EthPrivateKey.fromHex(privateKey).address;
    ethPrivateKey = privateKey;
    ethAddress = address;
  }

  Future getAssets() async {
    Map<String, dynamic> networks = networkInfo;

    try {
      List data = [];
      double totalBal = 0.0;

      Map<Object, Map<String, Object>> allNetworks = networks['networksInfo'];
      Map<Object, Map<String, Object>> rpcUrls = networks['rpcUrls'];
      allNetworks.forEach((key, value) async {
        double? bal = 0.0;

        String address = ethAddress!.toString();
        // print(key);
        if (rpcUrls[key] != null) {
          bal = await getNativeETHBalances(rpcUrls[key]!['testnet'], ethAddress);
        } else if (key == 'Bitcoin') {
          address = btcAddress!;
          bal = await getBTCBalance(ethAddress);
        } else {
          Map<String, dynamic>? rpc = value;
          print(rpc['rpc']['testnet']);
          bal = await getERC20Balance(value['address'], rpc['rpc']['testnet']);
        }

        List? marketData = await getPrices(value['nameoncoinmarketcap']);
        totalBal = totalBal + (bal ?? 0);
        // // print(marketData);
        Map<String, dynamic> assetData = {
          'displayName': value['displayName'],
          'logoUrl': value['logoUrl'],
          'ticker': value['ticker'],
          'bal': bal.toString(),
          'address': address,
          "24h_price_change": marketData != null && marketData.isNotEmpty ? marketData[1] : 0,
          "current_price": marketData != null && marketData.isNotEmpty ? marketData[0] : 0,
        };
        String price = ((assetData['current_price'] * double.parse(assetData['bal']))).toStringAsPrecision(2);

        totalBal = totalBal + double.parse(price);
        print(totalBal);
        assetData['bal_to_price'] = price;
        data.add(assetData);
        totalBalance = totalBal.toStringAsPrecision(2);
      });
      assets = data;
    } catch (e) {
      print({"error 120": e});
    }
  }

  Future<double> getBTCBalance(address) async {
    try {
      var url =
          Uri.parse("https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&community_data=false&developer_data=false&sparkline=false");
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return 0.0;
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  Future<double> getNativeETHBalances(rpc, address) async {
    try {
      var httpClient = http.Client();
      var ethClient = Web3Client(rpc, httpClient);
      EtherAmount balance = await ethClient.getBalance(ethAddress!);
      double bal = balance.getValueInUnit(EtherUnit.ether);
      return bal;
    } catch (e) {
      print({"error   142": e});
      return 0.0;
    }
  }

  Future getERC20Balance(address, rpc) async {
    try {
      var httpClient = http.Client();
      var ethClient = Web3Client(rpc, httpClient);

      ERC20 erc20Contract = ERC20(address: EthereumAddress.fromHex(address), client: ethClient);

      var bal = await erc20Contract.balanceOfERC20Token(ethAddress!);
      return bal;
    } catch (e) {
      print(rpc);
      print({"error   158": e});
    }
  }

  Future<List> getPrices(coinId) async {
    try {
      var url =
          Uri.parse("https://api.coingecko.com/api/v3/coins/$coinId?localization=false&community_data=false&developer_data=false&sparkline=false");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map res = json.decode(response.body);
        List data = [
          double.parse(double.parse(res['market_data']['current_price']['usd'].toString()).toStringAsFixed(2)),
          double.parse(double.parse(res['market_data']['price_change_percentage_24h'].toString()).toStringAsFixed(2)),
        ];
        // print('*********************');
        // print(coinId);
        // print(data);
        // print('*********************');
        return data;
      }
      return [];
    } catch (e) {
      print({"error   getPrices": e});
      return [];
    }
  }
}
