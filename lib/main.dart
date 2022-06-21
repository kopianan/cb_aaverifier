import 'package:coinbit_verifier/controller/storage.dart';
import 'package:flutter/material.dart';
import 'package:rust_mpc_ffi/lib.dart';

String shareKey = "shared-key";
String presignKey = "presign-key";
void main() {
  CBRustMpc().setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
  final dkgText = TextEditingController();
  final presignText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                  controller: dkgText,
                  decoration: const InputDecoration(hintText: "Share Key Here"),
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
                          setState(() {
                            dkgState = false;
                          });
                        },
                        child: (dkgState)
                            ? const CircularProgressIndicator()
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
                          if (dkgText.text.isNotEmpty) {
                            await Storage.saveKey(shareKey, dkgText.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.green,
                                    content: Text("Key Saved")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.red,
                                content: Text("Can not save empty key")));
                          }
                        },
                        child: const Text("Save Key"),
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
                  "DKG Proccess",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: presignText,
                  decoration: const InputDecoration(hintText: "Share Key Here"),
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
                          final key = await Storage.loadKey(shareKey);
                          if (key != null) {
                            var doPresign =
                                await CBRustMpc().offlineSignWithJson(2, key);
                            presignText.text = doPresign.toString();
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
                            ? const CircularProgressIndicator()
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
                        onPressed: () {
                          if (dkgText.text.isNotEmpty) {
                            Storage.saveKey(presignKey, presignText.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.green,
                                    content: Text("Key Saved")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.red,
                                    content: Text("Can not save empty key")));
                          }
                        },
                        child: const Text("Save Key Share"),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
