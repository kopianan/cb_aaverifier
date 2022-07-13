import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SuccessDkgPage extends StatefulWidget {
  const SuccessDkgPage({Key? key}) : super(key: key);

  @override
  State<SuccessDkgPage> createState() => _SuccessDkgPageState();
}

class _SuccessDkgPageState extends State<SuccessDkgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Congratulation")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text("Your wallet was created"),
            ),
          ),
          CBBtnPrimary(
              text: "Back To Dashboard",
              onPressed: () async {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
