import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coinbit_verifier/models/tx_object_model.dart';
import 'package:coinbit_verifier/pages/key/key_page.dart';
import 'package:coinbit_verifier/service/notifications_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

import '../../service/storage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    NotificationService.checkPermission(context);
    FirebaseMessaging.instance.getInitialMessage();

    AwesomeNotifications().actionStream.listen(
      (ReceivedNotification receivedNotification) {
        if (receivedNotification.payload!['topics'] == "dkg") {
          Navigator.of(context).pushNamed('dkg_page');
        }
        if (receivedNotification.payload!['topics'] == "sign") {
          Navigator.of(context)
              .pushNamed('sign_page', arguments: receivedNotification.payload);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {},
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message);

      if (message.data['topics'] == 'sign') {
        //Get TxObject Json
        dynamic txObject = message.data['txObject'];
        dynamic payload = message.data['payload'];

        createSignNotification({
          'payload': payload,
          'txObject': txObject,
          'topics': 'sign',
        });
      }
      if (message.data['topics'] == 'dkg') {
        createNotification({
          "test": "test",
          "topics": "dkg",
        });
      }
      if (message.data['topics'] == 'offlinesign') {
        var sharedKey = await Storage.loadSharedKey(message.data['address']);
        log(sharedKey!);
        await Future.delayed(Duration(seconds: 3)); 
        final value =
            await CBRustMpc().offlineSignWithJson(2, sharedKey.toString());

        log("SAVE PRESIGN KEY TO LOCAL");
        await Storage.savePresignKey(message.data['address'], value);
      }
    });
  }

  void createNotification(Map<String, String> payload) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(1),
          channelKey: 'basic_channel',
          body: "TEST",
          payload: payload),
    );
  }

  void createSignNotification(Map<String, String> data) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(1),
        channelKey: 'basic_channel',
        body: "Sign",
        title: "SIGN REQUEST",
        //data => {topics, txObject, payload}
        payload: data,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("VERIFIER"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Text(
              "DKG Will receive notification. Click the banner and run DKG from the DKG Page",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const KeyPage(),
                  ));
                },
                child: const Text("KEY PAGE"),
              )
            ],
          )
        ],
      ),
    );
  }
}
