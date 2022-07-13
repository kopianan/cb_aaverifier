import 'dart:convert';
import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/features/home/presentation/bloc/home_bloc.dart';
import 'package:coinbit_verifier/features/sign/presentation/bloc/sign_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is OnGetDecryptedPresign) {
            //get the presign key and do sign

            context.read<SignBloc>().add(
                  CreateSigning(
                    presign: state.presign,
                    index: 2,
                    payload: payload,
                    address: txObject['from'],
                  ),
                );
          }
        },
        child: BlocBuilder<SignBloc, SignState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                            const CellLabelWidget(value: "From :"),
                            CellValueWidget(value: txObject['from']),
                          ],
                        ),
                        TableRow(
                          children: [
                            const CellLabelWidget(value: "To :"),
                            CellValueWidget(value: txObject['to']),
                          ],
                        ),
                        TableRow(
                          children: [
                            const CellLabelWidget(value: "MaxGas :"),
                            CellValueWidget(value: txObject['maxGas']),
                          ],
                        ),
                        TableRow(
                          children: [
                            const CellLabelWidget(value: "Nonce :"),
                            CellValueWidget(value: txObject['gasPrice']),
                          ],
                        ),
                        TableRow(
                          children: [
                            const CellLabelWidget(value: "Value :"),
                            CellValueWidget(value: txObject['value']),
                          ],
                        ),
                        TableRow(
                          children: [
                            const CellLabelWidget(value: "Data :"),
                            CellValueWidget(value: txObject['data']),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CBBtnPrimary(
                    text: "Sign",
                    onPressed: () async {
                      context.read<HomeBloc>().add(GetAndDecryptPresign());
                    },
                  ),
                ],
              ),
            );
          },
        ),
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
