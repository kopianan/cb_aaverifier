import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:coinbit_verifier/service/mpc_service.dart';
import 'package:coinbit_verifier/service/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rust_mpc_ffi/lib.dart';
import 'package:web3dart/web3dart.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final txObject = json.decode(args['txObject']!);
    final payload = (args['payload']!);

    return Scaffold(
      appBar: AppBar(
        title: Text("SIGN"),
      ),
      body: Container(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Text("FROM"),
                    SizedBox(width: 20),
                    Text(txObject['from']),
                  ],
                ),
                Row(
                  children: [
                    Text("To"),
                    SizedBox(width: 20),
                    Text(txObject['to']),
                  ],
                ),
                Row(
                  children: [
                    Text("MaxGas"),
                    SizedBox(width: 20),
                    Text(txObject['maxGas']),
                  ],
                ),
                Row(
                  children: [
                    Text("Nonce"),
                    SizedBox(width: 20),
                    Text(txObject['nonce']),
                  ],
                ),
                Row(
                  children: [
                    Text("Value"),
                    SizedBox(width: 20),
                    Text(txObject['value']),
                  ],
                ),
                Row(
                  children: [
                    Text("Data"),
                    SizedBox(width: 20),
                    Text(txObject['data']),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                //Load Presign Key   
                var _data = await Storage.loadPresignKey(txObject['from']);
                log(_data.toString());
                log(payload);
                var _sign = await CBRustMpc()
                    .sign(2, _data!, Uint8List.fromList(payload.codeUnits));
                print(_sign);
              },
              child: Text("Sign"),
            )
          ],
        ),
      ),
    );
  }
}
