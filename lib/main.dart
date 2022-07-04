import 'dart:typed_data';
import 'package:coinbit_verifier/pages/dkg/dkg_page.dart';
import 'package:coinbit_verifier/pages/sign/sign_page.dart';
import 'package:coinbit_verifier/service/fcm_service.dart';
import 'package:coinbit_verifier/service/notifications_service.dart';
import 'package:coinbit_verifier/firebase_options.dart';
import 'package:coinbit_verifier/pages/dashboard/dashboard_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService.initializeAwesomeNotification();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FCMService.subscribeFCM();
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        "dkg_page": (_) => DKGPage(),
        "sign_page": (_) => SignPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardPage(),
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
        title: const Text("Verifier"),
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
                  //     Row(
                  //       children: [
                  //         Expanded(
                  //           flex: 3,
                  //           child: ElevatedButton(
                  //             onPressed: () async {
                  //               setState(() {
                  //                 dkgState = true;
                  //               });
                  //               var doDkg = await CBRustMpc().proccessDkgString(2);
                  //               dkgText.text = doDkg.toString();
                  //               await Storage.saveKey(SHAREKEY, doDkg.toString());
                  //               setState(() {
                  //                 dkgState = false;
                  //               });
                  //             },
                  //             child: (dkgState)
                  //                 ? Transform.scale(
                  //                     scale: 0.8,
                  //                     child: const CircularProgressIndicator(
                  //                       color: Colors.white,
                  //                     ),
                  //                   )
                  //                 : const Text("Do DKG (With Index 2)"),
                  //           ),
                  //         ),
                  //         const SizedBox(width: 20),
                  //         Expanded(
                  //           flex: 2,
                  //           child: ElevatedButton(
                  //             style: ButtonStyle(
                  //                 backgroundColor:
                  //                     MaterialStateProperty.all(Colors.red)),
                  //             onPressed: () async {
                  //               var key = await Storage.loadKey(SHAREKEY);
                  //               if (key != null) {
                  //                 dkgText.text = key;
                  //               } else {
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                     SnackBar(
                  //                         duration: Duration(seconds: 3),
                  //                         backgroundColor: Colors.red,
                  //                         content: Text("Key Shared Not Found")));
                  //               }
                  //             },
                  //             child: const Text("Load Key"),
                  //           ),
                  //         ),
                  //       ],
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(height: 60),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       "Offline Sign Proccess",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     TextField(
                  //       maxLines: 3,
                  //       minLines: 3,
                  //       controller: presignText,
                  //       decoration:
                  //           const InputDecoration(hintText: "Presign Key Here"),
                  //     ),
                  //     const SizedBox(height: 20),
                  //     Row(
                  //       children: [
                  //         Expanded(
                  //           flex: 3,
                  //           child: ElevatedButton(
                  //             onPressed: () async {
                  //               setState(() {
                  //                 presignState = true;
                  //               });
                  //               if (dkgText.text.isNotEmpty) {
                  //                 var doPresign = await CBRustMpc()
                  //                     .offlineSignWithJson(2, dkgText.text);
                  //                 presignText.text = doPresign.toString();

                  //                 await Storage.saveKey(
                  //                     PRESIGNKEY, doPresign.toString());
                  //               } else {
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                     const SnackBar(
                  //                         duration: Duration(seconds: 3),
                  //                         backgroundColor: Colors.red,
                  //                         content: Text("Share Key Empty")));
                  //               }

                  //               setState(() {
                  //                 presignState = false;
                  //               });
                  //             },
                  //             child: presignState == true
                  //                 ? Transform.scale(
                  //                     scale: 0.8,
                  //                     child: const CircularProgressIndicator(
                  //                       color: Colors.white,
                  //                     ),
                  //                   )
                  //                 : const Text("Do Presign (With Index 2)"),
                  //           ),
                  //         ),
                  //         const SizedBox(width: 20),
                  //         Expanded(
                  //           flex: 2,
                  //           child: ElevatedButton(
                  //             style: ButtonStyle(
                  //                 backgroundColor:
                  //                     MaterialStateProperty.all(Colors.red)),
                  //             onPressed: () async {
                  //               var key = await Storage.loadKey(PRESIGNKEY);
                  //               if (key != null) {
                  //                 presignText.text = key;
                  //               } else {
                  //                 ScaffoldMessenger.of(context).showSnackBar(
                  //                     const SnackBar(
                  //                         duration: Duration(seconds: 3),
                  //                         backgroundColor: Colors.red,
                  //                         content: Text("Key Shared Not Found")));
                  //               }
                  //             },
                  //             child: const Text("Load Presign"),
                  //           ),
                  //         ),
                  //       ],
                  //     )
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

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
}
