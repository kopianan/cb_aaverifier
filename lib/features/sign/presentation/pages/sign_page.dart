import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/core/services/storage.dart';
import 'package:coinbit_verifier/features/sign/presentation/bloc/sign_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rust_mpc_ffi/lib.dart';
import 'package:web3dart/web3dart.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final txObject = json.decode(args['txObject']!);
    final payload = (args['payload']!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("SIGN"),
      ),
      body: BlocBuilder<SignBloc, SignState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Expanded(
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(6),
                    },
                    children: [
                      TableRow(
                        children: [
                          CellLabelWidget(value: "From :"),
                          CellValueWidget(value: txObject['from']),
                        ],
                      ),
                      TableRow(
                        children: [
                          CellLabelWidget(value: "To :"),
                          CellValueWidget(value: txObject['to']),
                        ],
                      ),
                      TableRow(
                        children: [
                          CellLabelWidget(value: "MaxGas :"),
                          CellValueWidget(value: txObject['maxGas']),
                        ],
                      ),
                      TableRow(
                        children: [
                          CellLabelWidget(value: "Nonce :"),
                          CellValueWidget(value: txObject['gasPrice']),
                        ],
                      ),
                      TableRow(
                        children: [
                          CellLabelWidget(value: "Value :"),
                          CellValueWidget(value: txObject['value']),
                        ],
                      ),
                      TableRow(
                        children: [
                          CellLabelWidget(value: "Data :"),
                          CellValueWidget(value: txObject['data']),
                        ],
                      ),
                    ],
                  ),
                ),
                CBBtnPrimary(
                  text: "Sign",
                  onPressed: () async {
                    context.read<SignBloc>().add(CreateSigning(
                          index: 2,
                          payload: payload,
                          address: txObject['from'],
                        ));
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class CellLabelWidget extends StatelessWidget {
  const CellLabelWidget({Key? key, required this.value}) : super(key: key);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        value,
        style: CBText.regulerBody15px.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class CellValueWidget extends StatelessWidget {
  const CellValueWidget({Key? key, required this.value}) : super(key: key);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        value,
        style: CBText.regulerBody14px,
      ),
    );
  }
}
