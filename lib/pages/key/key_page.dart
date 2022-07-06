import 'package:flutter/material.dart';

import '../../core/services/storage.dart';

class KeyPage extends StatefulWidget {
  const KeyPage({Key? key}) : super(key: key);

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  String sharedKey = "Shared Key Here";
  final sharedController = TextEditingController();
  final presignController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KEY"),
        centerTitle: true,
      ),
      body: Column(children: [
        ElevatedButton(
            onPressed: () async {
              final _result = await Storage.loadAllKey();
              sharedKey = _result.toString();
              sharedController.text = sharedKey;
              setState(() {});
            },
            child: Text("Load Shared Key")),
        TextField(
          controller: sharedController,
          maxLines: 5,
          minLines: 5,
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () async {
              final _result = await Storage.loadAllKey();
              sharedKey = _result.toString();
              sharedController.text = sharedKey;
              setState(() {});
            },
            child: Text("Load Presign Key")),
        TextField(
          maxLines: 5,
          minLines: 5,
          controller: sharedController,
        ),
      ]),
    );
  }
}
