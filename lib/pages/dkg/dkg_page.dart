import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rust_mpc_ffi/lib.dart';

import '../../service/mpc_service.dart';
import '../../service/storage.dart';

class DKGPage extends StatefulWidget {
  const DKGPage({Key? key}) : super(key: key);

  @override
  State<DKGPage> createState() => _DKGPageState();
}

class _DKGPageState extends State<DKGPage> {
  bool isDkg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("DKG Proccess"),
      ),
      body: Column(
        children: [
          Center(
            child: const Text(
              "User request for DKG",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            height: 60,
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                //Shared Key Verifier
                final value = await CBRustMpc().proccessDkgString(2);
                //change hex to uint
                // CBRustMpc().sign()

                log("SAVE SHARE KEY TO LOCAL");
                final eth = await MPCService().generateAddress(value);
                await Storage.saveSharedKey(eth.hex, value.toString());
              },
              child: (!isDkg)
                  ? Text("DO DKG")
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
