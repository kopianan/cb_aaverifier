import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:web3dart/web3dart.dart';

class MPCService {
  Future<EthereumAddress> generateAddress(String sharedKey) async {
    var dcodejson = json.decode(sharedKey);
    List<int> point =
        (dcodejson['y_sum_s']['point'] as List).map((e) => e as int).toList();

    /// convert point to ECPoint, generate address from ECPoint
    var a = ECCurve_secp256k1();
    var b = a.curve.decodePoint(point);
    var c = Uint8List.view(b!.getEncoded(false).buffer, 1);
    EthereumAddress address = EthereumAddress.fromPublicKey(c);
    return address;
  }
}
