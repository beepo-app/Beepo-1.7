import 'package:web3dart/web3dart.dart' as web3;
import 'package:web3dart/web3dart.dart';

final _erc20ContractAbi = web3.ContractAbi.fromJson(
    '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function"}]',
    'Erc20');

class ERC20 {
  // Future<double> balanceOfERC20Token(
  //   web3.EthereumAddress account, {
  //   web3.BlockNum? atBlock,
  // }) async {
  //   final function = self.abi.functions[2];
  //   assert(checkSignature(function, '70a08231'));
  //   final params = [account];
  //   final response = await read(function, params, atBlock);

  //   return (response[0] as BigInt).toInt() > 0 ? (response[0] as BigInt).toInt() / 1000000000000000000 : 0.0;
  // }

  // Future<String> transfer(
  //   web3.EthereumAddress recipient,
  //   BigInt amount, {
  //   required web3.Credentials credentials,
  // }) async {
  //   final function = self.abi.functions[7];
  //   assert(checkSignature(function, 'a9059cbb'));
  //   final params = [recipient, amount];

  //   Transaction transaction = Transaction.callContract(
  //     contract: self,
  //     function: function,
  //     parameters: params,
  //   );
  //   return write(credentials, transaction, function, params);
  // }

  Future<List<dynamic>> query(String functionName, List<dynamic> args, ethClient, contractAddress) async {
    final contract = await loadContract(contractAddress);
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<DeployedContract> loadContract(contractAddress) async {
    final contract = DeployedContract(_erc20ContractAbi, EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<double> getBalance(EthereumAddress credentialAddress, ethClient, contractAddress) async {
    List<dynamic> response = await query("balanceOf", [credentialAddress], ethClient, contractAddress);
    return (response[0] as BigInt).toInt() > 0 ? (response[0] as BigInt).toInt() / 1000000000000000000 : 0.0;
  }

  Future<String> sendERC20Token(String functionName, List<dynamic> args, Web3Client ethClient, Credentials key, contractAddress, ethAddress) async {
    DeployedContract contract = await loadContract(contractAddress);
    final ethFunction = contract.function(functionName);

    var nonce = await ethClient.getTransactionCount(ethAddress);
    BigInt chainID = await ethClient.getChainId();
    var gasPrice = await ethClient.getGasPrice();

    print('nonce 60: $nonce');
    print('nonce 60: $chainID');
    try {
      var txHash = await ethClient.sendTransaction(
        key,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          maxGas: 100000,
          gasPrice: EtherAmount.inWei(gasPrice.getInWei),
          nonce: await ethClient.getTransactionCount(ethAddress, atBlock: const BlockNum.pending()),
          from: ethAddress,
        ),
        chainId: chainID.toInt(),
      );
      await Future.delayed(const Duration(seconds: 5));
      print(txHash);
      var transactionReceipt = await ethClient.getTransactionReceipt(txHash);
      print("Transaction receipt status: ${transactionReceipt?.status.toString()}");
    } catch (err) {
      print('rror 78 erc20 $err.toString()');
    }

    return 'end of tx';

    Transaction transaction = Transaction.callContract(contract: contract, function: ethFunction, parameters: args, maxGas: 100000);
    print(transaction.gasPrice);
    print(transaction.nonce);

    // BigInt chainID = await ethClient.getChainId();
    final result = await ethClient.sendTransaction(key, transaction, chainId: chainID.toInt());
    return result;
  }

  Future<String> sendNativeToken(Web3Client ethClient, Credentials key, toAddress, amount) async {
    BigInt chainID = await ethClient.getChainId();
    var res = await ethClient.sendTransaction(
      key,
      Transaction(
        to: EthereumAddress.fromHex(toAddress),
        gasPrice: EtherAmount.inWei(BigInt.one),
        maxGas: 100000,
        value: EtherAmount.fromInt(EtherUnit.ether, amount),
      ),
      chainId: chainID.toInt(),
    );

    print(res);
    return res;
  }
}
