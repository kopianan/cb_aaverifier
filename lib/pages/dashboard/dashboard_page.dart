import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coinbit_verifier/pages/key/key_page.dart';
import 'package:coinbit_verifier/pages/verifier/verifier_page.dart';
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

    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      print(receivedNotification.payload);
      Storage.clear();
      Navigator.of(context).pushNamed('dkg_page');
    });
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {},
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        createNotification({"test": "test"});
      }

      if (message.data['topics'] == 'offlinesign') {
        print(message.data['address']);
        var sharedKey = await Storage.loadKey(message.data['address']);
        CBRustMpc().offlineSignWithJson(2, sharedKey.toString()).then(
          (value) async {
            log("SAVE PRESIGN KEY TO LOCAL");
            await Storage.saveKey(message.data['address'] + "pk", value);
          },
        );
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
                    builder: (context) => KeyPage(),
                  ));
                },
                child: Text("KEY PAGE"),
              )
            ],
          )
        ],
      ),
    );
  }
}
