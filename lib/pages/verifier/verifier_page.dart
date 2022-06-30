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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DKG Proccess"),
      ),
      body: Column(
        children: [
          Text("User request for DKG"),
          ElevatedButton(
              onPressed: () async {
                final value = await CBRustMpc().proccessDkgString(2);

                log("SAVE SHARE KEY TO LOCAL");
                final eth = await MPCService().generateAddress(value);
                await Storage.saveKey(eth.hex, value.toString());
              },
              child: Text("DO DKG"))
        ],
      ),
    );
  }
}
