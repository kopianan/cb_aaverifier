import 'dart:typed_data';

import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:coinbit_verifier/core/services/fcm_service.dart';
import 'package:coinbit_verifier/features/recover/presentation/bloc/recover_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletRecoveryPage extends StatefulWidget {
  const WalletRecoveryPage({Key? key}) : super(key: key);

  @override
  State<WalletRecoveryPage> createState() => _WalletRecoveryPageState();
}

class _WalletRecoveryPageState extends State<WalletRecoveryPage> {
  final hashController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RecoverBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Recover Wallet"),
      ),
      body: BlocListener<RecoverBloc, RecoverState>(
        bloc: bloc,
        listener: (context, state) {
          print(state);
          if (state is OnRequestApproved) {
            Navigator.of(context).pop();
            print(state.presignKey);
            print(state.sharedKey);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Approved")));
          }
          if (state is OnRequestRecover) {
            //show dialog
            showDialog(
                context: context,
                builder: (context) {
                  return Container(
                    child: Column(
                      children: [
                        Center(child: CircleAvatar()),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                });
          }
          if (state is OnDownlodKeySuccess) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  child: Column(children: [
                    TextFormField(
                      controller: hashController,
                      decoration: InputDecoration(
                        labelText: "Input hash",
                      ),
                    ),
                    CBBtnPrimary(
                      text: "Decrypt And Save",
                      onPressed: () async {
                        final text = hashController.text;
                        final test =
                            text.replaceAll('[', '').replaceAll(']', '');
                        final listString = test.split(',');
                        final listInt =
                            listString.map((e) => int.parse(e)).toList();

                        final uint = Uint8List.fromList(listInt);
                        bloc.add(DecryptKey(state.encryptedKey, uint));
                      },
                    )
                  ]),
                );
              },
            );
          }
        },
        child: Column(children: [
          ListTile(
            leading: Icon(Icons.add_to_drive_sharp),
            title: Text("Get From Google Drive"),
            onTap: () {
              ///TODO:SOON
              // String hardCodeFileId = '1BIKNyQGyZ6cgPuWf7m3p2Dxi2Di_i_jM';
              // bloc.add(GetEncryptedKeyFromStorage(hardCodeFileId));

              FCMService().createRecoverRequest();
            },
          )
        ]),
      ),
    );
  }
}
