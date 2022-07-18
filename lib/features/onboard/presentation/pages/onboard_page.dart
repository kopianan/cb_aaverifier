import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../register/presentation/pages/components/register_pin.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
                child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CBBtnPrimary(
              text: "Let's Go",
              onPressed: () async {
                Navigator.of(context).pushNamed(
                  '/register_page',
                  arguments: ['', PinPageType.newPin],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
