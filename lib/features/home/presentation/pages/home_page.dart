import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/core/services/notifications_service.dart';

import 'package:coinbit_verifier/features/dkg/presentation/bloc/dkg_bloc.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage();

    NotificationService.checkPermission(context).then((value) {
      AwesomeNotifications().actionStream.listen(
        (ReceivedNotification receivedNotification) {
          if (receivedNotification.payload!['topics'] == "dkg") {
            Navigator.of(context).pushNamed('/dkg_page');
          }
          if (receivedNotification.payload!['topics'] == "sign") {
            Navigator.of(context).pushNamed('/sign_page',
                arguments: receivedNotification.payload);
          }
        },
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {},
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message);
      if (message.data['topics'] == 'dkg') {
        NotificationService.createDkgNotificationBanner(message.data);
      }
      if (message.data['topics'] == 'offlinesign') {
        Future.delayed(Duration(seconds: 3))
            .then((value) => context.read<DkgBloc>().add(
                  ProccessPresign(
                    index: 2,
                    address: message.data['address'],
                    hash: context.read<HomeBloc>().globalHash!,
                  ),
                ));
      }
      if (message.data['topics'] == 'sign') {
        NotificationService.createSignNotificationBanner(message.data);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.watch<HomeBloc>();
    log(homeBloc.address.toString(), name: "Home Address");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("VERIFIER"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/setting_page');
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/notification_page');
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                (homeBloc.address != null)
                    ? "This is your wallet"
                    : "Create Wallet should trigger from notification",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Visibility(
                visible: (homeBloc.address == null) ? true : false,
                child: CBBtnOutline(
                  text: "Recover Wallet",
                  onPressed: () async {
                    Navigator.of(context).pushNamed('/wallet_recovery_page');
                  },
                ))
          ],
        ),
      ),
    );
  }
}
