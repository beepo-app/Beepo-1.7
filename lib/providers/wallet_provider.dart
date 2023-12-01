import 'dart:convert';
import 'dart:io';

import 'package:Beepo/networks/erc20.dart';
import 'package:Beepo/networks/networks.dart';
import 'package:Beepo/widgets/toast.dart';
import 'package:decimal/decimal.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:flutter/foundation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:hex/hex.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart' as wallet;
import 'package:http/http.dart' as http;
import "package:ethereum_addresses/ethereum_addresses.dart";

class WalletProvider extends ChangeNotifier {
  String? ethPrivateKey;
  EthereumAddress? ethAddress;
  String? btcAddress;
  String? password;
  String? mnemonic;
  List? assets;
  String? totalBalance;
  Web3AuthResponse? mpcResponse;

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

  Future<String> initMPCWalletState(data) async {
    try {
      final address = EthPrivateKey.fromHex(data['privKey']).address;
      ethPrivateKey = data['privKey'];
      ethAddress = address;
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
        String rpcLink = '';
        bool native = false;

        String address = ethAddress!.toString();
        // print(key);
        if (rpcUrls[key] != null) {
          rpcLink = rpcUrls[key]!['testnet'].toString();
          bal = await getNativeETHBalances(rpcLink, ethAddress);
          native = true;
        } else if (key == 'Bitcoin') {
          address = btcAddress!;
          bal = await getBTCBalance(ethAddress);
        } else {
          Map<String, dynamic>? rpc = value;
          rpcLink = rpc['rpc']['testnet'];
          bal = await getERC20Balance(value['address'], rpcLink);
          // print(bal);
        }

        List? marketData = await getPrices(value['nameoncoinmarketcap']);
        totalBal = totalBal + (bal ?? 0);
        //print(marketData);
        Map<String, dynamic> assetData = {
          'displayName': value['displayName'],
          'logoUrl': value['logoUrl'],
          'ticker': value['ticker'],
          'nativeTicker': value['nativeTicker'],
          'bal': bal == null ? '0' : bal.toStringAsFixed(2),
          'chainID': value['chainId'],
          'rpc': rpcLink,
          'native': native,
          'address': address,
          'contractAddress': value['address'],
          "24h_price_change": marketData != null && marketData.isNotEmpty ? marketData[1] : 0,
          "current_price": marketData != null && marketData.isNotEmpty ? marketData[0] : 0,
        };
        String price = ((assetData['current_price'] * double.parse(assetData['bal']))).toStringAsFixed(2);

        totalBal = totalBal + double.parse(price);
        assetData['bal_to_price'] = price;
        data.add(assetData);
        totalBalance = totalBal.toStringAsFixed(2);
      });
      assets = data;
      return 'Done Fetching!';
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

      ERC20 erc20Contract = ERC20();

      var bal = await erc20Contract.getBalance(ethAddress!, ethClient, address);
      return bal;
    } catch (e) {
      print(rpc);
      print({"error   158": e});
    }
  }

  Future<Map> getTxs(chainID, type) async {
    try {
      var url = Uri.parse("https://get-transactions.vercel.app/api/getTxs?address=$ethAddress&chainID=$chainID&type=$type");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map res = json.decode(response.body);
        return res;
      }
      return {};
    } catch (e) {
      print({"error   getPrices": e});
      return {};
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

  Future importWallet(mnemonic_) async {
    final seed = bip39.mnemonicToSeed(mnemonic_);
    final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
    String privateKey = HEX.encode(master.key);
    final address = EthPrivateKey.fromHex(privateKey).address;
    return address;
  }

  Future sendERC20(
    contractAddress,
    toAddress,
    rpc,
    amount,
  ) async {
    try {
      checksumEthereumAddress(toAddress);

      var httpClient = http.Client();
      var ethClient = Web3Client(rpc, httpClient);

      EthPrivateKey key = EthPrivateKey.fromHex(ethPrivateKey!);

      ERC20 erc20 = ERC20();
      BigInt newAmount = BigInt.from(double.parse(amount) * 1e+18);

      var response =
          await erc20.sendERC20Token("transfer", [EthereumAddress.fromHex(toAddress), newAmount], ethClient, key, contractAddress, ethAddress);
      await getAssets();
      return response;
    } catch (e) {
      if (e.toString().contains('invalid address')) {
        showToast("Invalid Address Entered!");
      }
    }
  }

  Future estimateGasPrice(
    rpc,
  ) async {
    try {
      var httpClient = http.Client();
      var ethClient = Web3Client(rpc, httpClient);
      var gasPrice = await ethClient.getGasPrice();

      return (Decimal.parse((gasPrice.getInWei.toInt() / 1e+18).toString()));
    } catch (e) {
      print({"error (Wallet Provider)  220": e});
      if (e.toString().contains('invalid address')) {
        showToast("Invalid Address Entered!");
      }
    }
  }

  Future sendNativeToken(
    toAddress,
    rpc,
    amount,
  ) async {
    try {
      var httpClient = http.Client();
      var ethClient = Web3Client(rpc, httpClient);
      BigInt chainID = await ethClient.getChainId();

      var gasPrice = await ethClient.getGasPrice();

      var txHash = await ethClient.sendTransaction(
        EthPrivateKey.fromHex(ethPrivateKey!),
        Transaction(
          to: EthereumAddress.fromHex(toAddress),
          gasPrice: gasPrice,
          maxGas: 100000,
          value: EtherAmount.fromInt(EtherUnit.wei, (double.parse(amount) * 1e+18).toInt()),
          nonce: await ethClient.getTransactionCount(ethAddress!, atBlock: const BlockNum.pending()),
          from: ethAddress,
        ),
        chainId: chainID.toInt(),
      );
      await Future.delayed(const Duration(seconds: 5));

      var transactionReceipt = await ethClient.getTransactionReceipt(txHash);
      await getAssets();
      return transactionReceipt;
    } catch (e) {
      if (e.toString().contains('invalid address')) {
        showToast("Invalid Address Entered!");
      }
    }
  }

  Future<List> getNFTs(String chain, String address) async {
    try {
      var client = http.Client();

      // var response = await client.get(Uri.parse('https://api.opensea.io/api/v2/chain/$chain/account/$address/nfts'),
      //     headers: {"x-api-key": "a20f84e1347745a4b949d14162ee58a3"});

      var response = await client
          .get(Uri.parse('https://eth-mainnet.g.alchemy.com/nft/v3/HDQnQBbyr2HtgKSym1OqrbGED_H7Ev2N/getNFTsForOwner?owner=$address&pageSize=10'));

      print(response.body);
      if (response.body.isNotEmpty) {
        var nfts = jsonDecode(response.body);
        return nfts['nfts'];
      }
      return [];
    } catch (e) {
      return [
        {'error': e}
      ];
    }
  }

  Future<void> initPlatformState() async {
    Uri redirectUrls;
    if (Platform.isAndroid) {
      redirectUrls = Uri.parse('Beepo2.0https://Beepo2.0/auth');
    } else {
      throw UnKnownException('Unknown platform');
    }

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId: "BGaNpqXhzeQ8oKLtXECjffo6ynnBA-APd63zn9fTn9FsPmAqC1FzGdWoI4Yjumz73b9zqqYst3G_o9_iUo1KnLs",
        network: Network.testnet,
        redirectUrl: redirectUrls,
      ),
    );
  }

  Future<Map> web3AuthLogin() async {
    try {
      final Web3AuthResponse response =
          await Web3AuthFlutter.login(LoginParams(loginProvider: Provider.google, extraLoginOptions: ExtraLoginOptions(login_hint: 'Beepo')));
      mpcResponse = response;
      print(response);
      return response.toJson();
    } catch (e) {
      return {'error': e};
    }
  }
}
