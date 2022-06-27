import 'dart:developer';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:coinbit_verifier/controller/storage.dart';
import 'package:coinbit_verifier/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

String shareKey = "shared-key";
String presignKey = "presign-key";
String signKey = "sign-key";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize('resource://drawable/notify', [
    NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: "Descriptions")
  ]);
  CBRustMpc().setup();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then(
      (value) {
        if (!value) {
          AwesomeNotifications()
              .requestPermissionToSendNotifications()
              .then((value) => Navigator.of(context).pop());
        }
      },
    );
    FirebaseMessaging.instance
        .getToken()
        .then((value) => log(value.toString()));
    FirebaseMessaging.instance
        .subscribeToTopic("dkg")
        .then((value) => print("SUBSCRIBE TO DKG TOPIC"));

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      createNotification();
      CBRustMpc().proccessDkgString(2).then((value) => print(value));
    });
    super.initState();
  }

  void createNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: DateTime.now().millisecondsSinceEpoch.remainder(1),
          channelKey: 'basic_channel',
          body: "TEST"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool dkgState = false;
  bool presignState = false;
  bool signState = false;
  final dkgText = TextEditingController();
  final presignText = TextEditingController();
  final signText = TextEditingController();
  final uintText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verifier"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hi,\nIam The Verifier",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DKG Proccess",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    maxLines: 3,
                    minLines: 3,
                    controller: dkgText,
                    decoration:
                        const InputDecoration(hintText: "Share Key Here"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              dkgState = true;
                            });
                            var doDkg = await CBRustMpc().proccessDkgString(2);
                            dkgText.text = doDkg.toString();
                            await Storage.saveKey(shareKey, doDkg.toString());
                            setState(() {
                              dkgState = false;
                            });
                          },
                          child: (dkgState)
                              ? Transform.scale(
                                  scale: 0.8,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Do DKG (With Index 2)"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () async {
                            var key = await Storage.loadKey(shareKey);
                            if (key != null) {
                              dkgText.text = key;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      content: Text("Key Shared Not Found")));
                            }
                          },
                          child: const Text("Load Key"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Offline Sign Proccess",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    maxLines: 3,
                    minLines: 3,
                    controller: presignText,
                    decoration:
                        const InputDecoration(hintText: "Presign Key Here"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              presignState = true;
                            });
                            if (dkgText.text.isNotEmpty) {
                              var doPresign = await CBRustMpc()
                                  .offlineSignWithJson(2, dkgText.text);
                              presignText.text = doPresign.toString();
                              
                              await Storage.saveKey(
                                  presignKey, doPresign.toString());
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      content: Text("Share Key Empty")));
                            }

                            setState(() {
                              presignState = false;
                            });
                          },
                          child: presignState == true
                              ? Transform.scale(
                                  scale: 0.8,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Do Presign (With Index 2)"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () async {
                            
                            var key = await Storage.loadKey(presignKey);
                            if (key != null) {
                              presignText.text = key;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                      content: Text("Key Shared Not Found")));
                            }
                          },
                          child: const Text("Load Presign"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign Proccess",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 3,
                    minLines: 3,
                    controller: uintText,
                    decoration:
                        const InputDecoration(hintText: "Input UINT8LIST"),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          signState = true;
                        });
                        if (presignText.text.isNotEmpty &&
                            uintText.text.isNotEmpty) {
                          var uint = uintText as List<int>;
                          var doPresign = await CBRustMpc().sign(
                            2,
                            presignText.text,
                            Uint8List.fromList(uint),
                          );
                          signText.text = doPresign.toString();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                  content: Text("Signature Empty")));
                        }

                        setState(() {
                          signState = false;
                        });
                      },
                      child: signState == true
                          ? Transform.scale(
                              scale: 0.8,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text("Do Sign (With Index 2)"),
                    ),
                  ),
                  TextField(
                    maxLines: 3,
                    minLines: 3,
                    controller: signText,
                    decoration:
                        const InputDecoration(hintText: "RSV (Signature)"),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
